locals {
  tags = {
    "Environment" = "Production"
    "date"        = "19-08-2024"
  }

  microsoft_graph_modules = {
    modules = [
      {
        name    = "Microsoft.Graph"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Applications"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.applications"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Authentication"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.authentication"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Identity.DirectoryManagement"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.identity.directorymanagement"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Bookings"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.bookings"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Calendar"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.calendar"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.ChangeNotifications"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.changenotifications"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.CloudCommunications"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.cloudcommunications"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Compliance"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.compliance"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.CrossDeviceExperiences"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.crossdeviceexperiences"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Devices.CloudPrint"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.devices.cloudprint"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Devices.CorporateManagement"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.devices.corporatemanagement"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Devices.ServiceAnnouncement"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.devices.serviceannouncement"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.DeviceManagement"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.devicemanagement"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.DeviceManagement.Administration"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.devicemanagement.administration"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.DeviceManagement.Enrollment"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.devicemanagement.enrollment"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.DeviceManagement.Actions"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.devicemanagement.actions"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.DeviceManagement.Functions"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.devicemanagement.functions"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.DirectoryObjects"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.directoryobjects"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Education"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.education"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Files"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.files"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Groups"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.groups"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Identity.Governance"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.identity.governance"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Identity.SignIns"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.identity.signins"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Identity.Partner"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.identity.partner"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Mail"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.mail"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Notes"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.notes"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.People"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.people"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.PersonalContacts"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.personalcontacts"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Planner"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.planner"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Reports"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.reports"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.SchemaExtensions"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.schemaextensions"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Search"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.search"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Sites"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.sites"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Teams"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.teams"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Users.Actions"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.users.actions"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.Users"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.users"
        version = "2.23.0"
        type    = "nupkg"
      },
      {
        name    = "Microsoft.Graph.BackupRestore"
        uri     = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.backuprestore"
        version = "2.23.0"
        type    = "nupkg"
      },
    ]
  }

}