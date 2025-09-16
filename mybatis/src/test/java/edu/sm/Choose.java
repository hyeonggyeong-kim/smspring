package edu.sm;

import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.*;

import java.io.Reader;
import java.sql.Connection;
import java.sql.Statement;
import java.util.List;

public class Choose {

    // 결과 클래스
    public static class Item {
        public int id;
        public String name;
        public int price;

        @Override
        public String toString() {
            return "Item{id=" + id + ", name='" + name + "', price=" + price + "}";
        }
    }

    // 조건 클래스
    public static class Cond {
        public String mode;     // "name", "cheap", "expensive" 중 하나
        public String keyword;  // 이름 검색 키워드
    }

    // 매퍼 (choose 사용)
    interface ItemMapper {
        @Select({
                "<script>",
                "SELECT * FROM item",
                "<choose>",
                "   <when test='mode == \"name\" and keyword != null'>",
                "       WHERE name LIKE CONCAT('%', #{keyword}, '%')",
                "   </when>",
                "   <when test='mode == \"cheap\"'>",
                "       WHERE price &lt;= 1000",
                "   </when>",
                "   <when test='mode == \"expensive\"'>",
                "       WHERE price &gt;= 2000",
                "   </when>",
                "   <otherwise>",
                "       WHERE 1=1  <!-- 기본 전체 조회 -->",
                "   </otherwise>",
                "</choose>",
                "ORDER BY id",
                "</script>"
        })
        List<Item> chooseSearch(Cond cond);
    }

    public static void main(String[] args) throws Exception {
        // 1) MyBatis 설정 로드
        Reader reader = Resources.getResourceAsReader("mybatis_config.xml");
        SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader);

        try (SqlSession session = factory.openSession(true)) {
            Connection conn = session.getConnection();
            Statement stmt = conn.createStatement();

            // 2) 테이블/데이터 준비
            stmt.execute("CREATE TABLE item (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50), price INT)");
            stmt.execute("INSERT INTO item(name,price) VALUES " +
                    "('Apple',1000),('Banana',2000),('Carrot',500),('Avocado',3000)");

            ItemMapper mapper = session.getMapper(ItemMapper.class);

            // 이름 검색
            Cond c1 = new Cond();
            c1.mode = "name";
            c1.keyword = "A";
            System.out.println("== 이름 LIKE '%A%' ==");
            mapper.chooseSearch(c1).forEach(System.out::println);

            // 가격 1000 이하
            Cond c2 = new Cond();
            c2.mode = "cheap";
            System.out.println("\n== 가격 <= 1000 ==");
            mapper.chooseSearch(c2).forEach(System.out::println);

            // 가격 2000 이상
            Cond c3 = new Cond();
            c3.mode = "expensive";
            System.out.println("\n== 가격 >= 2000 ==");
            mapper.chooseSearch(c3).forEach(System.out::println);

            // 그 외 → 전체 조회
            Cond c4 = new Cond();
            c4.mode = "none";
            System.out.println("\n== 전체 조회 (otherwise) ==");
            mapper.chooseSearch(c4).forEach(System.out::println);
        }
    }
}
