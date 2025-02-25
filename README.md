# wogi
Wogi Assignment

## Objective
Develop a comprehensive App interface and API that fulfills the following specifications:

## Technology Stack

1. Utilize Rails 7.x with Ruby 3.1 for efficient development.
  
2. Employ PostgreSQL as the database management system for robust data handling.
  
3. Ensure API responses are formatted in JSON / JSON API to facilitate seamless
  integration.
  
4. Implement Rspec for rigorous and automated testing.
  
5. Enforce database integrity through the application of DB constraints and appropriate
  foreign keys.

## Functional Requirements

1. User Authentication:
     
   ○ Enable user registration and login using email credentials.
  
   ○ Preload default accounts through a seed mechanism.

2. Brand Management

   ○ Facilitate the addition of brands with the ability to define up to 5 customizable
  data fields for each brand.
  
3. Product Management:
   
   ○ Provide the capability to add, update, and delete products associated with
    brands.
   
   ○ Support up to 5 customizable data fields for each product.
   
   ○ Mandate inclusion of a price value for products, accommodating various
    currencies.

4. State Management:

   ○ Allow the manipulation of brand and product states, encompassing "active" and
    "inactive" options.
    
5. Client Management:

   ○ Enable the addition of clients with the option to define authentication credentials
    and payout rates.
    
6. Product Access Control:
     
   ○ Empower clients to specify accessible products for their accounts.
    
7. Card Issuance and Management:
     
   ○ Provide clients with the ability to request new cards for products.
   
   ○ Upon issuance, furnish clients with a unique activation number and an optional
    purchase details pin.
  
8. Card Cancellation:

   ○ Allow clients to cancel previously issued cards as needed.
    
9. Reporting:
      
   ○ Support the generation of comprehensive reports encompassing spending and
  card cancellation activities.

## Technical Requirements

1. API Development:
   
   ○ Develop a robust API using the Ruby On Rails framework to ensure a structured
  and maintainable codebase.
  
2. Authentication System:
   
   ○ Implement a secure authentication system to safeguard user accounts and
  sensitive operations.
  
3. Version Control:

   ○ Maintain a version-controlled repository on GitHub to facilitate collaborative
  development and code management.
