// repository/QSessionRepository.java
package edu.sm.app.repository;
import edu.sm.app.dto.Session;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface SessionRepository {

    @Insert("""
      INSERT INTO iq_session (cust_id, cate_id, status)
      VALUES (#{custId}, #{cateId}, 'WAITING')
    """)
    @Options(useGeneratedKeys = true, keyProperty = "sessionId")
    void insert(Session s);

    @Select("""
      SELECT 
        s.session_id AS sessionId, s.cust_id AS custId, s.admin_id AS adminId,
        s.cate_id AS cateId, c.cate_name AS cateName,
        s.status, s.requested_at AS requestedAt, s.started_at AS startedAt, s.ended_at AS endedAt
      FROM iq_session s JOIN cate c ON s.cate_id=c.cate_id
      WHERE s.status='WAITING'
      ORDER BY s.requested_at ASC
    """)
    List<Session> findWaiting();

    @Select("""
      SELECT 
        s.session_id AS sessionId, s.cust_id AS custId, s.admin_id AS adminId,
        s.cate_id AS cateId, c.cate_name AS cateName,
        s.status, s.requested_at AS requestedAt, s.started_at AS startedAt, s.ended_at AS endedAt
      FROM iq_session s JOIN cate c ON s.cate_id=c.cate_id
      WHERE s.session_id=#{sessionId}
    """)
    Session findById(long sessionId);

    // 동시클릭 방지: WAITING인 경우에만 배정되도록 WHERE에 상태 조건
    @Update("""
      UPDATE iq_session
      SET admin_id=#{adminId}, status='ACTIVE', started_at=NOW()
      WHERE session_id=#{sessionId} AND status='WAITING'
    """)
    int accept(@Param("sessionId") long sessionId, @Param("adminId") int adminId);

    @Update("""
      UPDATE iq_session
      SET status='ENDED', ended_at=NOW()
      WHERE session_id=#{sessionId} AND status<>'ENDED'
    """)
    int end(@Param("sessionId") long sessionId);
}
