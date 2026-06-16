-- Query: generate_payment
-- Purpose: Fallback transform for payment
-- Query Type: SELECT

WITH
    _source AS (
        SELECT *
        FROM <leading_table>
    )
SELECT
    pay_mstr.pay_id AS payment_id,
  pay_mstr.pay_inv AS invoice_id,
  pay_mstr.pay_date AS payment_date,
  pay_mstr.pay_method AS payment_method,
  pay_mstr.pay_amt AS payment_amount
FROM _source;