# MANAGEMENT TASKS

- (P1) Add LoginScreen to login before access MainScreen ✅
- (P2) AddEventScreen ✅
- (P2) EditEventScreen ✅
- (P3) Visibility of buttons to go NewEventScreen and UpdateEventScreen depends on user permissions -> It is related to RBAC system (Roles and permissions -> SaaS, AaaS)
- (P1) Unfocus every InputField ✅
- (P1) Refresh MainScreen when updating an event ✅
- (P1) Error validation in EditEventScreen (Only for title InputField and venue InputField) ✅
- (P1) Style CustomToast ✅
- (P1) Fix String when passing the value from MainScreen to EditEventScreen and set the date ✅
- (P2) Tests ✅
- (P2) Only show events which date is after today ✅
- (P1) TicketInfoScreen ✅
- (P2) Delete ticket feature ✅
- (P1) Cancel ticket feature ✅
- (P1) Visibility for 'Cancel ticket' functionality based on current status of the ticket ✅
- (P2) Sold, Cancel and Validate datetime ✅
- (P1) On deleting an event, delete all the tickets of that event ✅
- (P1) Let search references in lower or upper case ✅
- (P3) Support multiple tickets type and multiple prices for tickets of the same event
- (P3) 'Add tickets' feature
- (P2) Show TicketStatus history, with StatusLabel, Date and Time
- (P2) Add new feature of EventStatus (INCOMING, IN PROGRESS, FINISHED, CANCELED), and if some event is canceled, cancel all their tickets. Also, dont let buy new tickets if the event is 'IN PROGRESS' or 'FINISHED' or 'CANCELED'
- (P3) Support request access by email -> Need a new table that stores the user_id that requested the access
- (P1) Pagination in ticket filter -> Make an API call when typing something in searcher (with a debounce time of 500ms) ✅
- (P2) New table of ticket_status_history (ticket_id, status, status_datetime)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (P1) Widget tests
- (P1) Upload background and database to cloud provider
- (P2) Integration tests -> Many problems here