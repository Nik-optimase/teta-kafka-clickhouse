{% macro amount_bucket(amount) %}
    case
        when {{ amount }} < 50 then 'small'
        when {{ amount }} < 100 then 'medium'
        when {{ amount }} < 500 then 'large'
        else 'very_large'
    end
{% endmacro %}
