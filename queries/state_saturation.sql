-- Stacked histogram: workforce by state saturation and country rank
-- First, let R = workforce / jobs.
-- So R=0 is an empty state, R=1 is a full state, and anything over 1 is over capacity.
-- Then saturation = R in percentile form, rounded to the 1s place (e.g. 0.854 -> 85.40 -> 85)
with building_levels as (
    select b.id,
        sum(bo.levels) as levels
    from buildings b
        join building_ownership bo on bo.owned_building = b.id
    group by 1
),
state_vacancies as (
    select s.id,
        sum(
            (bl.levels - b.staffing) * if(b.building like '%rice%', 10000, 5000)
        ) as vacancies
    from states s
        join buildings b on b.state = s.id
        join building_levels bl on bl.id = b.id
    group by 1
),
state_pop as (
    select s.id,
        sum(p.workforce) as workforce,
        sum(
            if(
                p.workplace is null,
                p.workforce,
                0
            )
        ) as unemployed
    from states s
        join pops p on p.location = s.id
    group by 1
)
select least(
        cast(
            100.0 * sp.workforce / (sp.workforce + sv.vacancies - sp.unemployed) as integer
        ),
        150
    ) as saturation,
    cr.rank,
    sum(sp.workforce) as workforce
from state_vacancies sv
    join state_pop sp on sv.id = sp.id
    join states s on sv.id = s.id
    join country_rankings cr on s.country = cr.country
    join countries c on cr.country = c.id
group by saturation,
    cr.rank
order by saturation,
    cr.rank