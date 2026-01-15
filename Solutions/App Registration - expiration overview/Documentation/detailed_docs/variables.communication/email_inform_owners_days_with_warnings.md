# email_inform_owners_days_with_warnings

**File:** variables.communication.tf </br></br>
Define with a string on which days the owner of a SP should receive the notification. eg. 0,1,2 means they will receive the email on the day it expires, 1 day before and 2 days before and so on. (default 1,2,3,4,5,6,7,14,21,28,30)