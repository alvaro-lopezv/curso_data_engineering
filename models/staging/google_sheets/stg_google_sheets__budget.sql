{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='_fivetran_synced',
    begin='2025-01-28',
    batch_size='day',
    lookback=2
) }}

WITH stg_budget_products AS (
    SELECT * 
    FROM {{ source('google_sheets','budget') }}
    ),

renamed_casted AS (
    SELECT
          _row
        , month
        , quantity 
        , _fivetran_synced
    FROM stg_budget_products
    )

SELECT * FROM renamed_casted

{# {% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %} #}