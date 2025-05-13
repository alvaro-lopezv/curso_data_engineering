{{
  config(
    materialized='table'
  )
}}

WITH stg_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
),

renamed_casted AS (
    SELECT
        user_id
        , address_id
        , first_name
        , last_name
        , email
        , phone_number
        , CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc
        , CONVERT_TIMEZONE('UTC', updated_at) AS updated_at_utc
        , _fivetran_synced AS date_load
    FROM stg_users
    )

SELECT * FROM renamed_casted