{{
  config(
    materialized='table'
  )
}}

WITH stg_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
),

renamed_casted AS (
    SELECT
        order_id 
        , user_id 
        , promo_id
        , address_id
        , CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc
        , order_cost AS item_order_cost_usd
        , shipping_cost AS shipping_cost_usd
        , order_total AS total_order_cost_usd
        , tracking_id
        , shipping_service
        , CONVERT_TIMEZONE('UTC', estimated_delivery_at) AS estimated_delivery_at_utc
        , CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at_utc
		, status AS status_order
        , _fivetran_synced AS date_load
    FROM stg_orders
    )

SELECT * FROM renamed_casted