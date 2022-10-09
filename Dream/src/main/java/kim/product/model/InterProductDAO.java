package kim.product.model;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;

import kim.member.model.MemberVO;

public interface InterProductDAO {
	/** 제품상세 페이지에 들어가는 정보들 불러오기용 */ 
	ProductVO getDetail(String product_num) throws SQLException;
	
	/** 제품 번호 넢으면 재고수량 배열로 가져옴 */ 
	Map<String, ArrayList<String>> cnt_check(String productNum) throws SQLException;
	
	/** 카트 거치지 않고 바로구매시 가는 페이지에서 하는 결제 */
	int nocartPurchaseUpdate(Map<String, String> paraMap) throws SQLException;
	
	/** 제품 업데이트 */
	int UpdateProduct(Map<String, String> paraMap) throws SQLException;

}
