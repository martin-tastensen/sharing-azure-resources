variable "diagnostics_settings" {
  description = "Log analytics workspace name"
  type        = string
  default     = "la-nuuday-auditlogs"
}

variable "diagnostics_settings_retention_period" {
  description = "Define how long the log analtyics workspace should retain data. Note: the longer the higher the cost"
  type        = string
  default     = "30"
}