package edu.sm;

import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.*;

import java.io.Reader;
import java.sql.Connection;
import java.sql.Statement;
import java.util.List;

public class If {

    public static class Item {
        public int id;
        public String name;
        public int price;

        @Override
        public String toString() {
            return "Item{id=" + id + ", name='" + name + "', price=" + price + "}";
        }
    }

    public static class Cond {
        public String name;
        public Integer minPrice;
        public Integer maxPrice;
    }

    interface ItemMapper {
        @Select({
                "<script>",
                "SELECT * FROM item",
                "<where>",
                "  <if test='name != null and name != \"\"'>",
                "    AND name LIKE CONCAT('%', #{name}, '%')",
                "  </if>",
                "  <if test='minPrice != null'>",
                "    AND price &gt;= #{minPrice}",
                "  </if>",
                "  <if test='maxPrice != null'>",
                "    AND price &lt;= #{maxPrice}",
                "  </if>",
                "</where>",
                "ORDER BY id",
                "</script>"
        })
        List<Item> search(Cond cond);
    }

    public static void main(String[] args) throws Exception {
        Reader reader = Resources.getResourceAsReader("mybatis_config.xml");
        SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader);

        try (SqlSession session = factory.openSession(true)) {
            Connection conn = session.getConnection();
            Statement stmt = conn.createStatement();

            stmt.execute("CREATE TABLE item (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50), price INT)");
            stmt.execute("INSERT INTO item(name,price) VALUES " +
                    "('Apple',1000),('Banana',2000),('Carrot',500),('Avocado',3000)");

            ItemMapper mapper = session.getMapper(ItemMapper.class);

            System.out.println("== 전체 ==");
            mapper.search(new Cond()).forEach(System.out::println);

            Cond c1 = new Cond();
            c1.name = "A";
            System.out.println("\n== 이름 LIKE '%A%' ==");
            mapper.search(c1).forEach(System.out::println);

            Cond c2 = new Cond();
            c2.minPrice = 1500;
            System.out.println("\n== 가격 >= 1500 ==");
            mapper.search(c2).forEach(System.out::println);

            Cond c3 = new Cond();
            c3.maxPrice = 2000;
            System.out.println("\n== 가격 <= 2000 ==");
            mapper.search(c3).forEach(System.out::println);

            Cond c4 = new Cond();
            c4.name = "A";
            c4.minPrice = 1000;
            c4.maxPrice = 2500;
            System.out.println("\n== 이름 LIKE '%A%' AND 1000 <= 가격 <= 2500 ==");
            mapper.search(c4).forEach(System.out::println);
        }
    }
}
