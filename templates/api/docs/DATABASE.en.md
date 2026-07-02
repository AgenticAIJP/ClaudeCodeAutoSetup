# Database Design

> ⚠️ When changing the schema, update this file in the same change.

## Tables

<!-- TODO: define tables. Example: -->

### users

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK | user ID |
| email | text | UNIQUE NOT NULL | email address |
| created_at | timestamptz | NOT NULL | creation time |

## Relations

<!-- TODO: foreign keys / associations -->
