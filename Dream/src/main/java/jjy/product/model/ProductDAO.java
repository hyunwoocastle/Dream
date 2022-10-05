package jjy.product.model;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import choi.servicecenter.model.NoticeDTO;
import util.security.AES256;
import util.security.SecretMyKey;

public class ProductDAO implements InterProductDAO {
	// DBCP
	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private AES256 aes;

	// 생성자
	public ProductDAO() {

		try {
			// connection pool 을 위한 작업
			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			ds = (DataSource) envContext.lookup("jdbc/dream");

			aes = new AES256(SecretMyKey.KEY);// KEY는 스태틱 변수이기때문에 객체생성 필요 x
			// SecretMyKey.KEY 는 우리가 만든 비밀키이다.

		} catch (NamingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) { // key 가 16글자 미만인경우 발생하는 예외 처리
			e.printStackTrace();
		}
	}

	// 사용한 자원을 반납하는 close() 메소드 생성하기
	private void close() {

		try {
			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
			if (conn != null) {
				conn.close();
				conn = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} // end of try ~ catch()---------------------------------

	}

	// 필터에 맞는 총 게시물 수를 알아오는 메소드
	@Override
	public int cntAllProduct(Map<String, String> paraMap) throws SQLException {
		String category = paraMap.get("category");
		String detail_category = paraMap.get("detail_category");
		String bestyn = paraMap.get("bestyn");
		String gender = paraMap.get("gender");
		String start_price = paraMap.get("start_price");
		String end_price = paraMap.get("end_price");
		int total_cnt = 1;
		try {
			conn = ds.getConnection();

			String sql = " select count(*) from tbl_product " + " where 1=1 ";
			if (category != null) {
				sql += " and category = '" + category + "'";
			}
			if (detail_category != null) {
				sql += " and detail_category = " + detail_category;
			}
			if (bestyn != null) {
				sql += " and bestyn = " + bestyn;
			}
			if (gender != null) {
				sql += " and gender = " + gender;
			}
			if (start_price != null && end_price != null) {
				sql += " and price = between " + Integer.parseInt(sql) + " and " + end_price;
			}

			pstmt = conn.prepareStatement(sql);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				total_cnt = rs.getInt(1);
			}

		} finally {
			close();
		}
		return total_cnt;
	}

	// 페이징처리를해서, 제품들을 셀렉트해오는 메소드
	@Override
	public List<ProductDTO> selectAllProduct(Map<String, String> paraMap) throws SQLException {
		List<ProductDTO> productList = new ArrayList<>();
		try {
			conn = ds.getConnection();
			String sql = " select product_num " + "      , register_date " + "      , product_name "
					+ "      , product_image " + "      , category " + "      , detail_category " + "      , price "
					+ "      , discount_rate " + "      , gender" + " from  " + " ( " + " select rownum R "
					+ "      , product_num " + "      , register_date " + "      , product_name "
					+ "      , product_image " + "      , category " + "      , detail_category " + "      , price "
					+ "      , discount_rate " + "      , gender " + " from tbl_product "
					+ " order by product_num desc " + " )A  " + " where R between (?*?)-(?-1) and (?*?) ";
//					(조회하고자하는페이지번호 * 한페이지당보여줄행의개수) - (한페이지당보여줄행의개수 - 1) and (조회하고자하는페이지번호 * 한페이지당보여줄행의개수);
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(paraMap.get("page")));
			pstmt.setInt(2, Integer.parseInt(paraMap.get("display_cnt")));
			pstmt.setInt(3, Integer.parseInt(paraMap.get("display_cnt")));
			pstmt.setInt(4, Integer.parseInt(paraMap.get("page")));
			pstmt.setInt(5, Integer.parseInt(paraMap.get("display_cnt")));

			rs = pstmt.executeQuery();

			while (rs.next()) {
				ProductDTO pdto = new ProductDTO(); // dto 하나 생성
				pdto.setProduct_num(rs.getInt("product_num"));
				pdto.setRegister_date(rs.getString("register_date"));
				pdto.setProduct_name(rs.getString("product_name"));
				pdto.setProduct_image(rs.getString("product_image"));
				pdto.setCategory(rs.getString("category"));
				pdto.setDetail_category(rs.getString("detail_category"));
				pdto.setPrice(rs.getInt("price"));
				pdto.setDiscount_rate(rs.getFloat("discount_rate"));
				pdto.setGender(rs.getString("gender"));

				productList.add(pdto); // NoticeDTO들만 들어갈 수 있는 리스트에 담기
			}
		} finally {
			close();
		}
		return productList;

	}

	
	// Map 으로 상품명,상품이미지,대카테고리,소카테고리,가격,할인율,성별,제품상세설명을 전달받아 제품 등록하는 메소드 (insert) 
	@Override
	public int registProduct(Map<String, String> productMap) throws SQLException {
		
		int result = 0;
	      
	      try {
	         conn = ds.getConnection();
	         
	         String sql = " insert into tbl_product(product_num , register_date, product_name, product_image, "
	         			+ " category, detail_category, price, discount_rate, gender, product_content, bestyn ) "+
	        		      " values(SEQ_PRODUCT_NUM.nextval,sysdate, ? , ? , ? , ? ,"
	        		      + " ? , ? , ? , ?,'N') ";
	         
	         // (SEQ_PRODUCT_NUM.nextval,sysdate,'상품명 1' , '상품이미지 2 ', '대카테고리3', '소카테고리4',가격 5 ,할인율6 ,'성별7','제품상세설명8','N');
	         
	         pstmt = conn.prepareStatement(sql);
	         
	         pstmt.setString(1, productMap.get("product_name"));
	         pstmt.setString(2, productMap.get("product_image"));    
	         pstmt.setString(3, productMap.get("category")); 
	         pstmt.setString(4, productMap.get("detail_category")); 
	         pstmt.setInt(5, Integer.parseInt(productMap.get("price")));    
	         pstmt.setFloat(6, Float.parseFloat(productMap.get("discount_rate")));    
	         pstmt.setString(7, productMap.get(""));    
	         pstmt.setString(8, productMap.get("product_content"));
	         
	         result = pstmt.executeUpdate();
	         
	      } finally {
	         close();
	      }
	      
	      return result;   
		
	}

	
	// 대카테고리 침구류,수면용품,파자마,조명 구해오기 
	@Override
	public List<String> getCagegory() throws SQLException {
		
		List<String> categoryList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			String sql = " select DISTINCT category "
					   + " from tbl_product ";
			pstmt = conn.prepareStatement(sql);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				categoryList.add(rs.getString(("category"))); 
			}
		} finally {
			close();
		}
		
		return categoryList;
	}// end of public List<String> getCagegory() throws SQLException {}-----------------------------

	
	
	// 대카테고리를 전달받아 그에 맞는 소카테고리 구해오는 메소드 
	@Override
	public List<String> getDetailCategory(String category) throws SQLException {
		
		List<String> detailCategoryList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			String sql = " select DISTINCT detail_category "
					   + " from tbl_product "
					   + " where category = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, category);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				detailCategoryList.add(rs.getString(("category"))); 
			}
		} finally {
			close();
		}
		
		return detailCategoryList;
		
	}// end of public List<String> getDetailCategory(String category) {}-----------------------

	
	
	
	
}
