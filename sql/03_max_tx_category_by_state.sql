SELECT
    state,
    category,
    amount
FROM
(
    SELECT
        state,
        category,
        amount,
        row_number() OVER (PARTITION BY state ORDER BY amount DESC) AS rn
    FROM teta.transactions_optimized
)
WHERE rn = 1
ORDER BY state
FORMAT CSVWithNames;
