resource "azurerm_logic_app_workflow" "la_expiration_notification" {
  name                = "la_expiration-notification"
  location            = var.location
  resource_group_name = azurerm_resource_group.baseline_resource_group.name

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags

  parameters = { "$connections" = jsonencode({
    "${azapi_resource.Azure_communication_service_API_Connection.name}" = {
      connectionId   = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.baseline_resource_group.name}/providers/Microsoft.Web/connections/${azapi_resource.Azure_communication_service_API_Connection.name}"
      connectionName = "${azapi_resource.Azure_communication_service_API_Connection.name}"
      id             = "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${azurerm_resource_group.baseline_resource_group.location}/managedApis/acsemail"
    },

    "${azapi_resource.Azure_Logic_app_blob_storage_connection.name}" = {
      connectionId   = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.baseline_resource_group.name}/providers/Microsoft.Web/connections/${azapi_resource.Azure_Logic_app_blob_storage_connection.name}"
      connectionName = "${azapi_resource.Azure_Logic_app_blob_storage_connection.name}"
      id             = "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${azurerm_resource_group.baseline_resource_group.location}/managedApis/azureblob"
      connectionProperties = {
        authentication = {
          type = "ManagedServiceIdentity"
        }
      }

    }
  }) }

  workflow_parameters = {
    "$connections" = jsonencode({
      defaultValue = {}
      type         = "Object"
  }) }

  depends_on = [
    azurerm_email_communication_service_domain.AzureManagedDomain,
    azurerm_email_communication_service.mmt-email-communication-service,
    azurerm_communication_service.mmt-notification-service,
    azapi_resource.Azure_communication_service_API_Connection
  ]
}

resource "azapi_resource" "Azure_communication_service_API_Connection" {
  type      = "Microsoft.Web/connections@2016-06-01"
  name      = "acsemail"
  parent_id = azurerm_resource_group.baseline_resource_group.id
  location  = azurerm_resource_group.baseline_resource_group.location
  tags      = local.tags
  lifecycle {
    ignore_changes = all
  }
  body = jsonencode({
    properties = {
      displayName = "acsemail"
      parameterValues = {
        api_key = azurerm_communication_service.mmt-notification-service.primary_connection_string
      }
      customParameterValues = {}

      api = {
        name        = "acsemail"
        displayName = "Azure Communication Email"
        description = "Connector to send Email using the domains linked to the Azure Communication Services in your subscription"
        iconUri     = "https://connectoricons-prod.azureedge.net/releases/v1.0.1677/1.0.1677.3631/acsemail/icon.png"
        brandColor  = "#3C1D6E"
        id          = "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${azurerm_resource_group.baseline_resource_group.location}/managedApis/acsemail"
        type        = "Microsoft.Web/locations/managedApis"
      }
    }
  })
}

####################################################################################


resource "azapi_resource" "Azure_Logic_app_blob_storage_connection" {
  type                      = "Microsoft.Web/connections@2016-06-01"
  name                      = "azureblob"
  parent_id                 = azurerm_resource_group.baseline_resource_group.id
  location                  = azurerm_resource_group.baseline_resource_group.location
  tags                      = local.tags
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      displayName = "azureblob"

      parametervalueset = {
        name   = "managedIdentityAuth"
        values = {}
      }


      api = {
        name        = "azureblob"
        displayName = "Azure Blob Storage"
        description = "Microsoft Azure Storage provides a massively scalable, durable, and highly available storage for data on the cloud, and serves as the data storage solution for modern applications. Connect to Blob Storage to perform various operations such as create, update, get and delete on blobs in your Azure Storage account."
        iconUri     = "https://connectoricons-prod.azureedge.net/u/patelronak/getmetadataforfolderfix/1.0.1704.3829/azureblob/icon.png"
        brandColor  = "#804998"
        id          = "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${azurerm_resource_group.baseline_resource_group.location}/managedApis/azureblob"
        type        = "Microsoft.Web/locations/managedApis"
      }
    }
  })
}

resource "azurerm_logic_app_trigger_http_request" "wf_la_expiration_notification" {
  name         = "When a HTTP request is received"
  logic_app_id = azurerm_logic_app_workflow.la_expiration_notification.id


  schema = <<SCHEMA
{
    "type": "object",
    "properties": {
        "sp_displayname": {
            "type": "string"
        },
        "sp_object_id": {
            "type": "string"
        },
        "sp_application_id": {
            "type": "string"
        },
        "secret_type": {
            "type": "string"
        },
        "secret_status": {
            "type": "string"
        },
        "secret_DisplayName": {
            "type": "string"
        },
        "secret_EndDateTime": {
            "type": "string"
        },
        "secret_days_until_secret_expires": {
            "type": "integer"
        },
        "secret_Hint": {
            "type": "string"
        },
        "Secret_Text": {},
        "secret_Key": {},
        "secret_keyid": {
            "type": "string"
        },
        "secret_StartDateTime": {
            "type": "string"
        },
        "tenant_id": {
            "type": "string"
        },
        "tenant_name": {
            "type": "string"
        },
        "owner_displayname": {
            "type": "string"
        },
        "owner_mail": {
            "type": "string"
        },
        "owner_userprincipalname": {
            "type": "string"
        },
        "owner_id": {
            "type": "string"
        },
        "request_type": {
            "type": "string"
        },
        "blob_file_name": {
            "type": "string"
        },
        "mail_subject": {
            "type": "string"
        }
    }
}
SCHEMA
  depends_on = [
    azurerm_logic_app_workflow.la_expiration_notification,
    azurerm_email_communication_service_domain.AzureManagedDomain,
    azurerm_email_communication_service.mmt-email-communication-service,
    azurerm_communication_service.mmt-notification-service,
  ]
}

## https://jsonlint.com/ <-- I'm using this tool to cleanup the json. Totally recommend it when working with logic apps
resource "azurerm_logic_app_action_custom" "if_else_statement" {
  name         = "if_else_condition"
  logic_app_id = azurerm_logic_app_workflow.la_expiration_notification.id


  body = <<BODY
{
    "type": "If",
    "expression": {
        "and": [
            {
                "equals": [
                    "@triggerBody()?['request_type']",
                    "single_user"
                ]
            }
        ]
    },
    "actions": {
        "Send_email_to_known_owners": {
            "inputs": {
                "body": {
                    "content": {
                        "html": "<p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Azure Notification:</strong></b> A @{triggerBody()?['secret_type']} is about to, or have expired on @{triggerBody()?['sp_displayname']}</p><br><h1 class=\"editor-heading-h1\">Basic info</h1><p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Tenant ID:</strong></b> @{triggerBody()?['tenant_id']}</p><p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Displayname:</strong></b> @{triggerBody()?['sp_displayname']}</p><p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Application id:</strong></b> @{triggerBody()?['sp_application_id']}</p><p class=\"editor-paragraph\"></p><br><h1 class=\"editor-heading-h1\">Expiration details</h1><p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Secret type: </strong></b>@{triggerBody()?['secret_type']}</p><p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Secret status: </strong></b>@{triggerBody()?['secret_status']}</p><p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Creation date:</strong></b> @{triggerBody()?['secret_StartDateTime']}</p><p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Expiration date:</strong></b> @{triggerBody()?['secret_EndDateTime']}</p><p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Days until expiration: </strong></b>@{triggerBody()?['secret_days_until_secret_expires']}</p><p class=\"editor-paragraph\"></p><br><h1 class=\"editor-heading-h1\">Extra info</h1><p class=\"editor-paragraph\"><b><strong class=\"editor-text-bold\">Secret description: </strong></b>@{triggerBody()?['secret_text']}</p>",
                        "subject": "Azure Notification: A @{triggerBody()?['secret_type']} is about to, or have expired on @{triggerBody()?['sp_displayname']}"
                    },
                    "importance": "Normal",
                    "recipients": {
                        "to": [
                            {
                                "address": "@triggerBody()?['owner_mail']"
                            }
                        ]
                    },
                    "senderAddress": "DoNotReply@${azurerm_email_communication_service_domain.AzureManagedDomain.from_sender_domain}"
                },
                "host": {
                    "connection": {
                        "name": "@parameters('$connections')['acsemail']['connectionId']"
                    }
                },
                "method": "post",
                "path": "/emails:sendGAVersion",
                "queries": {
                    "api-version": "2023-03-31"
                }
            },
            "type": "ApiConnection"
        }
    },
    "else": {
        "actions": {
            "Lists_blobs_(V2)": {
              "description": "This will list all blobs for use in the logic app workflow. We need the value later in this step",
              "inputs": {
                  "host": {
                      "connection": {
                          "name": "@parameters('$connections')['azureblob']['connectionId']"
                      }
                  },
                  "method": "get",
                  "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('${azurerm_storage_container.blob_storage_temp.storage_account_name}'))}/foldersV2/@{encodeURIComponent(encodeURIComponent('JTJmdGVtcC1zdG9yYWdl'))}",
                  "queries": {
                      "nextPageMarker": "",
                      "useFlatListing": false
                  }
              },
              "metadata": {
                  "JTJmdGVtcC1zdG9yYWdl": "/temp-storage"
              },
              "type": "ApiConnection"
            },
            "Get_blob_content_(V2)": {
              "description": "Get the csv file that we stored in the storage account in the powershell script. After this step it will be available in the logic app to be send in the e-mail in the next step",
              "inputs": {
                  "host": {
                      "connection": {
                          "name": "@parameters('$connections')['azureblob']['connectionId']"
                      }
                  },
                  "method": "get",
                  "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('${azurerm_storage_container.blob_storage_temp.storage_account_name}'))}/files/@{encodeURIComponent(encodeURIComponent('/${azurerm_storage_container.blob_storage_temp.name}/',triggerBody()?['blob_file_name']))}/content",
                  "queries": {
                      "inferContentType": true
                  }
              },
              "metadata": {
                  "JTJmdGVtcC1zdG9yYWdlJTJmbm9fb3duZXJzX3NwLmNzdg==": "/${azurerm_storage_container.blob_storage_temp.name}/',triggerBody()?['blob_file_name']))}/content"
              },
              "runAfter": {
                  "Lists_blobs_(V2)": [
                      "Succeeded"
                  ]
              },
              "type": "ApiConnection"
            },
            "Switch": {
                "cases": {
                    "Case": {
                        "actions": {
                            "find_all_SP_with_expired_keys_and_secrets": {
                                "description": "Send e-mail with the attachement for each of the lists that has been decided using variables. The variables can be found in the automation account variables blade",
                                "inputs": {
                                    "body": {
                                        "attachments": [
                                            {
                                                "contentInBase64": "@{base64(body('Get_blob_content_(V2)'))}",
                                                "contentType": "csv",
                                                "name": "@triggerBody()?['blob_file_name']"
                                            }
                                        ],
                                        "content": {
                                            "html": "<h1 class=\"editor-heading-h1\">Azure Notification</h1><p class=\"editor-paragraph\">This is the overview containing all Service Principals with expiret secrets or certificates in Entra ID.</p><p class=\"editor-paragraph\"><br>The data is collected for the tenant id: @{triggerBody()?['tenant_id']}</p>",
                                            "subject": "Entra ID notification: @{triggerBody()?['mail_subject']}"
                                        },
                                        "importance": "Normal",
                                        "recipients": {
                                            "to": [
                                                {
                                                    "address": "@triggerBody()?['owner_mail']"
                                                }
                                            ]
                                        },
                                        "senderAddress": "DoNotReply@${azurerm_email_communication_service_domain.AzureManagedDomain.mail_from_sender_domain}"
                                    },
                                    "host": {
                                        "connection": {
                                            "name": "@parameters('$connections')['acsemail']['connectionId']"
                                        }
                                    },
                                    "method": "post",
                                    "path": "/emails:sendGAVersion",
                                    "queries": {
                                        "api-version": "2023-03-31"
                                    }
                                },
                                "type": "ApiConnection"
                            },
                            "find_all_SP_with_expired_keys_and_secrets_-_Delete_blob_(V2)": {
                                "description": "After the file has been send, it will be deleted again to avoid cluttering the Storage account. ",
                                "inputs": {
                                    "headers": {
                                        "SkipDeleteIfFileNotFoundOnServer": false
                                    },
                                    "host": {
                                        "connection": {
                                            "name": "@parameters('$connections')['azureblob']['connectionId']"
                                        }
                                    },
                                    "method": "delete",
                                    "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('${azurerm_storage_account.storage_account_temp_storage.name}'))}/files/@{encodeURIComponent(encodeURIComponent('/${azurerm_storage_container.blob_storage_temp.name}/',triggerBody()?['blob_file_name']))}"
                                },
                                "metadata": {
                                    "JTJmdGVtcC1zdG9yYWdlJTJmbm9fb3duZXJzX3NwLmNzdg==": "/${azurerm_storage_container.blob_storage_temp.name}/',triggerBody()?['blob_file_name']))}/content"
                                },
                                "runAfter": {
                                    "find_all_SP_with_expired_keys_and_secrets": [
                                        "Succeeded"
                                    ]
                                },
                                "type": "ApiConnection"
                            }
                        },
                        "case": "find_all_SP_with_expired_keys_and_secrets"
                    },
                    "Case 2": {
                        "actions": {
                            "find_all_SPs_where_secret_is_about_to_expire_": {
                                "description": "Send e-mail with the attachement for each of the lists that has been decided using variables. The variables can be found in the automation account variables blade",
                                "inputs": {
                                    "body": {
                                        "attachments": [
                                            {
                                                "contentInBase64": "@{base64(body('Get_blob_content_(V2)'))}",
                                                "contentType": "csv",
                                                "name": "@triggerBody()?['blob_file_name']"
                                            }
                                        ],
                                        "content": {
                                            "html": "<h1 class=\"editor-heading-h1\">Azure Notification</h1><p class=\"editor-paragraph\">This is the overview containing all Service Principals and all secrets and certificates that are about to expire in Entra ID.</p><br><p class=\"editor-paragraph\">The data is collected for the @{triggerBody()?['tenant_id']}</p>",
                                            "subject": "Entra ID notification: @{triggerBody()?['mail_subject']}"
                                        },
                                        "importance": "Normal",
                                        "recipients": {
                                            "to": [
                                                {
                                                    "address": "@triggerBody()?['owner_mail']"
                                                }
                                            ]
                                        },
                                        "senderAddress": "DoNotReply@${azurerm_email_communication_service_domain.AzureManagedDomain.mail_from_sender_domain}"
                                    },
                                    "host": {
                                        "connection": {
                                            "name": "@parameters('$connections')['acsemail']['connectionId']"
                                        }
                                    },
                                    "method": "post",
                                    "path": "/emails:sendGAVersion",
                                    "queries": {
                                        "api-version": "2023-03-31"
                                    }
                                },
                                "type": "ApiConnection"
                            },
                            "find_all_SPs_where_secret_is_about_to_expire_-_Delete_Blob_(V2)": {
                                "description": "Delete the export after the mail have been send",
                                "inputs": {
                                    "headers": {
                                        "SkipDeleteIfFileNotFoundOnServer": false
                                    },
                                    "host": {
                                        "connection": {
                                            "name": "@parameters('$connections')['azureblob']['connectionId']"
                                        }
                                    },
                                    "method": "delete",
                                    "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('${azurerm_storage_account.storage_account_temp_storage.name}'))}/files/@{encodeURIComponent(encodeURIComponent('/${azurerm_storage_container.blob_storage_temp.name}/',triggerBody()?['blob_file_name']))}"
                                },
                                "metadata": {
                                    "JTJmdGVtcC1zdG9yYWdlJTJmbm9fb3duZXJzX3NwLmNzdg==": "/${azurerm_storage_container.blob_storage_temp.name}/',triggerBody()?['blob_file_name']))}/content"
                                },
                                "runAfter": {
                                    "find_all_SPs_where_secret_is_about_to_expire_": [
                                        "Succeeded"
                                    ]
                                },
                                "type": "ApiConnection"
                            }
                        },
                        "case": "find_all_SPs_where_secret_is_about_to_expire"
                    },
                    "Case 3": {
                        "actions": {
                            "get_list_of_orphaned_Service_Principals": {
                                "description": "Send e-mail with the attachement for each of the lists that has been decided using variables. The variables can be found in the automation account variables blade",
                                "inputs": {
                                    "body": {
                                        "attachments": [
                                            {
                                                "contentInBase64": "@{base64(body('Get_blob_content_(V2)'))}",
                                                "contentType": "csv",
                                                "name": "@triggerBody()?['blob_file_name']"
                                            }
                                        ],
                                        "content": {
                                            "html": "<h1 class=\"editor-heading-h1\">Azure Notification</h1><p class=\"editor-paragraph\">This is the overview containing all Service Principals that are currently lacking an owner. the lists includes an overview of certificates and secrets assigned to the Service principal in Entra ID</p><p class=\"editor-paragraph\"></p><br><p class=\"editor-paragraph\">The data is collected for the @{triggerBody()?['tenant_id']}</p>",
                                            "subject": "Entra ID notification: @{triggerBody()?['mail_subject']}"
                                        },
                                        "importance": "Normal",
                                        "recipients": {
                                            "to": [
                                                {
                                                    "address": "@triggerBody()?['owner_mail']"
                                                }
                                            ]
                                        },
                                        "senderAddress": "DoNotReply@${azurerm_email_communication_service_domain.AzureManagedDomain.mail_from_sender_domain}"
                                    },
                                    "host": {
                                        "connection": {
                                            "name": "@parameters('$connections')['acsemail']['connectionId']"
                                        }
                                    },
                                    "method": "post",
                                    "path": "/emails:sendGAVersion",
                                    "queries": {
                                        "api-version": "2023-03-31"
                                    }
                                },
                                "type": "ApiConnection"
                            },
                            "get_list_of_orphaned_Service_Principals_-_Delete_blob_(V2)": {
                                "description": "Delete the export after the mail have been send",
                                "inputs": {
                                    "headers": {
                                        "SkipDeleteIfFileNotFoundOnServer": false
                                    },
                                    "host": {
                                        "connection": {
                                            "name": "@parameters('$connections')['azureblob']['connectionId']"
                                        }
                                    },
                                    "method": "delete",
                                    "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('${azurerm_storage_account.storage_account_temp_storage.name}'))}/files/@{encodeURIComponent(encodeURIComponent('/${azurerm_storage_container.blob_storage_temp.name}/',triggerBody()?['blob_file_name']))}"
                                },
                                "metadata": {
                                    "JTJmdGVtcC1zdG9yYWdlJTJmbm9fb3duZXJzX3NwLmNzdg==": "/${azurerm_storage_container.blob_storage_temp.name}/',triggerBody()?['blob_file_name']))}/content"
                                },
                                "runAfter": {
                                    "get_list_of_orphaned_Service_Principals": [
                                        "Succeeded"
                                    ]
                                },
                                "type": "ApiConnection"
                            }
                        },
                        "case": "get_list_of_orphaned_Service_Principals"
                    }
                },
                "default": {
                    "actions": {}
                },
                "expression": "@triggerBody()?['request_type']",
                "runAfter": {
                    "Get_blob_content_(V2)": [
                        "Succeeded"
                    ]
                },
                "type": "Switch"
          }
        }
    },
    "runAfter": {}
}
BODY
  depends_on = [
    azurerm_logic_app_trigger_http_request.wf_la_expiration_notification,
    azapi_resource.Azure_communication_service_API_Connection,
    azapi_resource.Azure_Logic_app_blob_storage_connection,
  ]
}
 