package edu.sm.app.repository;

import edu.sm.app.dto.Marker;
import edu.sm.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
// import org.springframework.stereotype.Repository;  // 선택사항

import java.util.List;

@Mapper   // ✅ MyBatis가 이 인터페이스를 Mapper로 인식
// @Repository  // 선택사항(굳이 없어도 됨)
public interface MarkerRepository extends SmRepository<Marker, Integer> {

    // loc로 조회
    List<Marker> findByLoc(@Param("loc") String loc);   // ✅ @Param

    // 반경 내 조회
    List<Marker> selectWithinRadius(@Param("lat") double lat,
                                    @Param("lng") double lng,
                                    @Param("radiusKm") double radiusKm,
                                    @Param("limit") Integer limit);
}
