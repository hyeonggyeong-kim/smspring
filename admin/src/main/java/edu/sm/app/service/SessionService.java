package edu.sm.app.service;
import edu.sm.app.dto.Session;
import edu.sm.app.repository.SessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service @RequiredArgsConstructor
public class SessionService {
    private final SessionRepository repo;

    public Session request(int custId, int cateId){
        Session s = Session.builder().custId(custId).cateId(cateId).build();
        repo.insert(s);
        return repo.findById(s.getSessionId());
    }
    public List<Session> waiting(){ return repo.findWaiting(); }
    public Session get(long id){ return repo.findById(id); }

    @Transactional
    public boolean accept(long sessionId, int adminId){
        return repo.accept(sessionId, adminId) == 1;
    }
    @Transactional
    public boolean end(long sessionId){
        return repo.end(sessionId) == 1;
    }
}
