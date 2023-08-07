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
