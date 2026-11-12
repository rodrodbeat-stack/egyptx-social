# Connect Supabase to EGYPTX

## 1. Create a Supabase project
Create a project in Supabase and keep its Project URL and publishable (anon) key available. Never put the service_role/secret key in browser code or commit it to GitHub.

## 2. Create the database
Open **SQL Editor → New query**, paste the contents of `supabase/schema.sql`, and run it. It creates profiles, posts, comments, likes, follows, row-level security policies, and the `egyptx-media` Storage bucket.

## 3. Configure authentication
In **Authentication → URL Configuration**, add your deployed site URL and local development URL to the allowed redirect URLs. Enable the sign-in methods you want (email/password is a good starting point).

## 4. Frontend connection
The browser will use only the Project URL and publishable/anon key. The private service_role key must remain server-side.

## Important
The current website is still a frontend prototype. Running the SQL creates the backend tables and security rules, but does not by itself connect the browser UI to Supabase. The next integration step is to add the public project settings and wire registration, login, feed reads, and post creation.
