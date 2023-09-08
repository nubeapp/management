/* 
  +----------------------------+
  |     Mock User Responses    |
  +----------------------------+
*/

const mockUserListResponse = [
  {
    "id": 1,
    "name": "John",
    "surname": "Doe",
    "email": "johndoe@example.com",
  },
  {
    "id": 2,
    "name": "Jane",
    "surname": "Smith",
    "email": "janesmith@example.com",
  }
];

const mockUserResponse = {
  "id": 1,
  "name": "John",
  "surname": "Doe",
  "email": "johndoe@example.com",
};

/* 
  +----------------------------+
  |     Mock Auth Responses    |
  +----------------------------+
*/

const mockTokenResponse = {
  "access_token":
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
  "token_type": "bearer"
};

/* 
  +----------------------------+
  |     Mock Event Responses   |
  +----------------------------+
*/

const mockEventListResponse = [
  {
    "id": 1,
    "title": "Bad Bunny Concert",
    "date": "2023-12-07T18:00:00+01:00",
    "time": "18:00",
    "venue": "Wizink Center",
    "organization_id": 1,
    "organization": {
      "id": 1,
      "name": "UNIVERSAL MUSIC SPAIN",
    },
  },
  {
    "id": 2,
    "title": "Rosalia Concert",
    "date": "2023-12-14T18:00:00+01:00",
    "time": "18:00",
    "venue": "Wizink Center",
    "organization_id": 1,
    "organization": {
      "id": 1,
      "name": "UNIVERSAL MUSIC SPAIN",
    },
  }
];

const mockEventResponse = {
  "id": 1,
  "title": "Bad Bunny Concert",
  "venue": "Wizink Center",
  "date": "2023-12-07T18:00:00+01:00",
  "time": "18:00",
  "ticket_limit": 1000,
  "organization_id": 1,
  "organization": {
    "id": 1,
    "name": "UNIVERSAL MUSIC SPAIN",
  },
};

/* 
  +----------------------------+
  |    Mock Ticket Responses   |
  +----------------------------+
*/

final mockTicketSummaryListResponse = [
  {
    "count": 2,
    "event": {
      "id": 1,
      "title": "Bad Bunny Concert",
      "date": "2023-12-07T18:00:00+01:00",
      "time": "18:00",
      "venue": "Wizink Center",
      "organization": {"id": 1, "name": "UNIVERSAL MUSIC SPAIN"}
    },
    "tickets": [
      {"id": 1, "reference": "2IR6ZOULKL2HOARDUI19", "price": 10.0, "status": "SOLD"},
      {"id": 2, "reference": "ZT1HT93LEGSVCIEEGAIJ", "price": 10.0, "status": "SOLD"}
    ]
  },
  {
    "count": 2,
    "event": {
      "id": 2,
      "title": "Rosalia Concert",
      "date": "2023-12-14T18:00:00+01:00",
      "time": "18:00",
      "venue": "Wizink Center",
      "organization": {"id": 1, "name": "UNIVERSAL MUSIC SPAIN"}
    },
    "tickets": [
      {"id": 3, "reference": "4JUAEAWPB1S6KSSWPN80", "price": 20.0, "status": "SOLD"},
      {"id": 4, "reference": "Y3OPY34TJ9FH78UV4BXG", "price": 20.0, "status": "SOLD"},
    ]
  }
];

final mockTicketSummaryResponse = {
  "count": 2,
  "event": {
    "id": 1,
    "title": "Bad Bunny Concert",
    "date": "2023-12-07T18:00:00+01:00",
    "time": "18:00",
    "venue": "Wizink Center",
    "organization": {"id": 1, "name": "UNIVERSAL MUSIC SPAIN"}
  },
  "tickets": [
    {"id": 1, "reference": "2IR6ZOULKL2HOARDUI19", "price": 10.0, "status": "SOLD"},
    {"id": 2, "reference": "ZT1HT93LEGSVCIEEGAIJ", "price": 10.0, "status": "SOLD"}
  ]
};

final mockTicketSummaryAvailablesResponse = {
  "count": 2,
  "event": {
    "id": 1,
    "title": "Bad Bunny Concert",
    "date": "2023-12-07T18:00:00+01:00",
    "time": "18:00",
    "venue": "Wizink Center",
    "organization": {"id": 1, "name": "UNIVERSAL MUSIC SPAIN"}
  },
  "tickets": [
    {"id": 1, "reference": "2IR6ZOULKL2HOARDUI19", "price": 10.0, "status": "AVAILABLE"},
    {"id": 2, "reference": "ZT1HT93LEGSVCIEEGAIJ", "price": 10.0, "status": "AVAILABLE"}
  ]
};

/* 
  +----------------------------+
  | Mock Organization Responses|
  +----------------------------+
*/

final mockOrganizationResponse = {
  "id": 1,
  "name": "UNIVERSAL MUSIC SPAIN",
};

const mockOrganizationListResponse = [
  {
    "id": 1,
    "name": "UNIVERSAL MUSIC SPAIN",
  },
  {
    "id": 2,
    "name": "WARNER BROS MUSIC",
  },
  {
    "id": 3,
    "name": "SONY MUSIC ENTERTAINMENT",
  }
];

/* 
  +------------------------------------+
  | Mock TicketStatusHistory Responses |
  +------------------------------------+
*/

const mockTicketStatusHistoryListResponse = [
  {
    "id": 1,
    "ticket_id": 11,
    "status": "AVAILABLE",
    "status_at": "2023-12-07T18:00:00+01:00",
  },
  {
    "id": 2,
    "ticket_id": 11,
    "status": "SOLD",
    "status_at": "2023-12-07T19:00:00+01:00",
  },
  {
    "id": 3,
    "ticket_id": 11,
    "status": "VALIDATED",
    "status_at": "2023-12-07T20:00:00+01:00",
  },
];
