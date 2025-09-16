package edu.sm;

import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.*;

import java.io.Reader;
import java.sql.Connection;
import java.sql.Statement;
import java.util.List;

public class Trim {

    // 결과 객체
    public static class Item {
        public int id;
        public String name;
        public Integer price;
        public String note;

        @Override
        public String toString() {
            return "Item{id=" + id + ", name='" + name + "', price=" + price + ", note='" + note + "'}";
        }
    }

    // 검색 조건 (WHERE용)
    public static class SearchCond {
        public String name;
        public Integer minPrice;
        public Integer maxPrice;
        public String noteContains;
    }

    // 수정 조건 (SET용)
    public static class UpdateCond {
        public String name;    // null 아니면 name=...
        public Integer price;  // null 아니면 price=...
        public String note;    // null 아니면 note=...
    }

    /** <trim prefix="WHERE" prefixOverrides="AND |OR "> 데모  */
    interface ItemSearchMapper {
        @Select({
                "<script>",
                "SELECT id,name,price,note FROM item",
                // WHERE를 직접 커스텀: 앞쪽 AND/OR 자동 제거
                "<trim prefix='WHERE' prefixOverrides='AND |OR '>",
                "  <if test='name != null and name != \"\"'>",
                "    AND name LIKE CONCAT('%', #{name}, '%')",
                "  </if>",
                "  <if test='minPrice != null'>",
                "    AND price &gt;= #{minPrice}",
                "  </if>",
                "  <if test='maxPrice != null'>",
                "    AND price &lt;= #{maxPrice}",
                "  </if>",
                "  <if test='noteContains != null and noteContains != \"\"'>",
                "    OR note LIKE CONCAT('%', #{noteContains}, '%')",
                "  </if>",
                "</trim>",
                "ORDER BY id",
                "</script>"
        })
        List<Item> search(SearchCond cond);
    }

    /** <trim prefix="SET" suffixOverrides=","> 데모 (UPDATE) */
    interface ItemUpdateMapper {
        @Update({
                "<script>",
                "UPDATE item",
                "<trim prefix='SET' suffixOverrides=','>",
                "  <if test='name  != null'> name  = #{name},  </if>",
                "  <if test='price != null'> price = #{price}, </if>",
                "  <if test='note  != null'> note  = #{note},  </if>",
                "</trim>",
                "WHERE id = #{id}",
                "</script>"
        })
        int updateById(int id, UpdateCond cond);
    }

    public static void main(String[] args) {
        try {
            run();
        } catch (Throwable t) {
            System.err.println("=== FATAL ===");
            t.printStackTrace();
        }
    }

    private static void run() throws Exception {
        // 1) MyBatis 설정 로드
        Reader reader = Resources.getResourceAsReader("mybatis_config.xml");
        SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader);

        try (SqlSession session = factory.openSession(true)) {
            // 2) 스키마/데이터 준비
            Connection conn = session.getConnection();
            Statement st = conn.createStatement();
            st.execute("CREATE TABLE item (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50), price INT, note VARCHAR(100))");
            st.execute("INSERT INTO item(name,price,note) VALUES " +
                    "('Apple',1000,'fresh')," +
                    "('Banana',2000,'ripe')," +
                    "('Carrot',500,'organic')," +
                    "('Avocado',3000,'premium')");

            ItemSearchMapper s = session.getMapper(ItemSearchMapper.class);
            ItemUpdateMapper u = session.getMapper(ItemUpdateMapper.class);

            // --- WHERE with <trim> 데모 ---
            System.out.println("\n== A) 조건 없음 → WHERE 생략 ==");
            s.search(new SearchCond()).forEach(System.out::println);

            System.out.println("\n== B) 첫 조건이 AND로 시작해도 정상 (prefixOverrides가 AND 제거) ==");
            SearchCond c1 = new SearchCond();
            c1.minPrice = 1500;           // AND price >= 1500
            c1.maxPrice = 3500;           // AND price <= 3500
            s.search(c1).forEach(System.out::println);

            System.out.println("\n== C) OR 조건 섞여도 앞쪽 OR 제거됨 (prefixOverrides='AND |OR ') ==");
            SearchCond c2 = new SearchCond();
            c2.noteContains = "organic";  // OR note LIKE '%organic%'
            s.search(c2).forEach(System.out::println);

            System.out.println("\n== D) 복합 (name LIKE '%A%' OR note LIKE '%organic%') AND price <= 3000 ==");
            SearchCond c3 = new SearchCond();
            c3.name = "A";
            c3.noteContains = "organic";
            c3.maxPrice = 3000;
            s.search(c3).forEach(System.out::println);

            // --- SET with <trim> 데모 ---
            System.out.println("\n== E) UPDATE: 특정 필드만 동적으로 SET (콤마 자동 정리) ==");
            UpdateCond upd = new UpdateCond();
            upd.price = 1800;             // price만 변경 (뒤의 콤마 자동 제거)
            int rows = u.updateById(2, upd); // id=2 (Banana)
            System.out.println("업데이트 행 수: " + rows);

            // 결과 확인
            SearchCond check = new SearchCond();
            check.name = "Banana";
            s.search(check).forEach(System.out::println);

            System.out.println("\n== F) UPDATE: name, note 둘 다 변경 (마지막 콤마 제거) ==");
            UpdateCond upd2 = new UpdateCond();
            upd2.name = "Banana-GOLD";
            upd2.note = "best-seller";
            rows = u.updateById(2, upd2);
            System.out.println("업데이트 행 수: " + rows);
            s.search(check).forEach(System.out::println);
        }
    }
}
