<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 도서관 자리예약</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="logo">🔐</div>
            <h2>로그인</h2>
            <p class="subtitle">도서관 자리예약 시스템</p>
            
            <!-- 에러 메시지 -->
            <c:if test="${error != null}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <!-- 성공 메시지 -->
            <c:if test="${success != null}">
                <div class="success-message">
                    ${success}
                </div>
            </c:if>
            
            <form action="/library/login" method="post" class="login-form">
                <div class="form-group">
                    <label for="userId">아이디</label>
                    <input type="text" id="userId" name="userId" required 
                           placeholder="아이디를 입력하세요">
                </div>
                
                <div class="form-group">
                    <label for="userPw">비밀번호</label>
                    <input type="password" id="userPw" name="userPw" required 
                           placeholder="비밀번호를 입력하세요">
                </div>
                
                <button type="submit" class="login-btn">로그인</button>
            </form>
            
            <div class="links">
                <a href="/library/register">회원가입</a>
                <span>|</span>
                <a href="${pageContext.request.contextPath}/forgot-password">비밀번호 찾기</a>
            </div>
            
            <div class="back-home">
                <a href="${pageContext.request.contextPath}/">← 홈으로 돌아가기</a>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>