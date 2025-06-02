package com.springboot.library.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.springboot.library.model.User;

@Mapper
public interface UserMapper {
    
    // 로그인용 - 아이디와 비밀번호로 사용자 찾기
    User findByUserIdAndPassword(@Param("userId") String userId, @Param("userPw") String userPw);
    
    // 회원가입용 - 사용자 등록
    void insertUser(User user);
    
    // 아이디 중복 체크
    int countByUserId(@Param("userId") String userId);
    
    // 사용자 정보 조회
    User findByUserId(@Param("userId") String userId);
}