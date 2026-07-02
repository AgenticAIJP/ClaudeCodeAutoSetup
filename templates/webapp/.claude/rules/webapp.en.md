# Web App Rules

- The frontend never accesses the DB directly. Always go through the backend API
- When changing the API boundary (request/response types), update frontend and backend in the same change
- Don't put raw API responses into frontend state; convert them to display types
- Backend business logic never lives in the routing layer; put it in the service layer
- Keep frontend / backend environment variables strictly separated (no secrets in the frontend)
