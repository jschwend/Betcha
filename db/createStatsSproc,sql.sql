DELIMITER //
CREATE PROCEDURE `GetStats`(IN pSeason INT, IN pWk INT)
BEGIN
select @z:=@z+1 AS MyRank
     , season
     , wk
     , school_nm
     , oyards_pg, oyards_rank
     , dyards_pg, dyards_rank
     , opts_pg, opts_rank
     , dpts_pg, dpts_rank
 from (
select oy.season
     , oy.wk
     , t.school_nm
     , oy.oyards_pg, oy.it as oyards_rank
     , dy.dyards_pg, dy.it as dyards_rank
     , op.opts_pg, op.it as opts_rank
     , dp.dpts_pg, dp.it as dpts_rank
from teams t
   , (select season, wk, team_id, oyards_pg, @a:=@a+1 AS it from stats, (SELECT @a:=0) foo where season=pSeason and wk=pWk order by oyards_pg desc) oy
   , (select season, wk, team_id, dyards_pg, @b:=@b+1 AS it from stats, (SELECT @b:=0) foo where season=pSeason and wk=pWk order by dyards_pg asc) dy
   , (select season, wk, team_id, opts_pg, @c:=@c+1 AS it from stats, (SELECT @c:=0) foo where season=pSeason and wk=pWk order by opts_pg desc) op
   , (select season, wk, team_id, dpts_pg, @d:=@d+1 AS it from stats, (SELECT @d:=0) foo where season=pSeason and wk=pWk order by dpts_pg asc) dp
where oy.team_id = dy.team_id
  and oy.team_id = op.team_id
  and oy.team_id = dp.team_id
  and oy.team_id = t.team_id
  and oy.season  = dy.season
  and oy.season  = op.season
  and oy.season  = dp.season
  and oy.wk  = dy.wk
  and oy.wk  = op.wk
  and oy.wk  = dp.wk
  and oy.season  = pSeason
  and oy.wk  = pWk
order by oy.season, oy.wk, oy.it + dy.it + op.it + dp.it, t.school_nm) l
   , (SELECT @z:=0) r;
  END//
DELIMITER ;