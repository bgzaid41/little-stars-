# Little Stars starter

Included: responsive storefront, category shop/search/filter, browser cart, Supabase signup/login, admin product add/edit/delete, SQL schema and Netlify config.

## Setup
1. Create a Supabase project and run `supabase/schema.sql` in SQL Editor.
2. Copy Project URL and anon/publishable key from Project Settings → API into `assets/js/config.js`.
3. Never put the service-role key in browser code.
4. Register your account at `/register.html`. Then grant yourself admin in SQL Editor: `insert into public.user_roles(user_id,role) select id,'admin' from auth.users where email='YOUR_EMAIL';`
5. Run locally with `python -m http.server 8000`, then open `http://localhost:8000`.
6. Deploy this folder to Netlify. Publish directory is `.`; no build command needed.

## Important limitations
This is a starter, not a production-audited store. Checkout/payment, stock reservation, image upload UI, customer order management, delivery/tax logic, email notifications and analytics are not complete. Cart is browser-local. Before taking real orders/payments, implement trusted server-side checkout with server-side price/stock validation and transactional stock updates; test all RLS policies. Never expose service-role credentials.
