# email_inform_owners_directly

**File:** variables.feature_activation.tf </br></br>
This boolean will define wether or not owners will be contacted directly on expiring or expired secrets and certificates. All owners of the specific SP will be contacted, but owners where the secret or certificate has not yet expired will be contacted first. The owners will be contacted on the days specified in the 'email_inform_owners_days_with_warnings' variable (default: true)