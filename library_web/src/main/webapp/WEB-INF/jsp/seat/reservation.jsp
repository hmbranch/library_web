<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>좌석 예약 - 도서관 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/seat.css">
    <style>
        .reservation-form {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #4a5568;
        }
        
        .form-select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        
        .form-select:focus {
            outline: none;
            border-color: #4299e1;
        }
        
        .available-seats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .seat-option {
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .seat-option:hover {
            border-color: #4299e1;
            background: #ebf8ff;
        }
        
        .seat-option.selected {
            border-color: #4299e1;
            background: #4299e1;
            color: white;
        }
        
        .seat-option input[type="radio"] {
            display: none;
        }
        
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .alert-error {
            background: #fed7d7;
            border: 1px solid #feb2b2;
            color: #c53030;
        }
        
        .alert-success {
            background: #c6f6d5;
            border: 1px solid #9ae6b4;
            color: #22543d;
        }
        
        .submit-btn {
            background: linear-gradient(135deg, #48bb78, #38a169);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(72, 187, 120, 0.3);
        }
        
        .submit-btn:disabled {
            background: #a0aec0;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📚 도서관 관리 시스템</h1>
        <div class="user-info">
            <span>안녕하세요, <strong>${loginUser.name}</strong>님!</span>
            <a href="/library/logout" class="logout-btn">로그아웃</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-header">
            <h2>📝 좌석 예약</h2>
            <div class="nav-buttons">
                <a href="/seats" class="btn btn-secondary">좌석 현황</a>
                <a href="/library" class="btn btn-secondary">홈으로</a>
            </div>
        </div>
        
        <!-- 에러/성공 메시지 -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
            </div>
        </c:if>
        
        <!-- 예약 폼 -->
        <div class="reservation-form">
            <h3>🪑 사용 가능한 좌석</h3>
            <p style="color: #718096; margin-bottom: 20px;">
                원하는 좌석과 이용 시간을 선택해주세요.
            </p>
            
            <c:choose>
                <c:when test="${empty availableSeats}">
                    <div class="alert alert-error">
                        현재 사용 가능한 좌석이 없습니다. 나중에 다시 시도해주세요.
                    </div>
                </c:when>
                <c:otherwise>
                    <form method="post" action="/seats/reserve" id="reservationForm">
                        <div class="form-group">
                            <label class="form-label">좌석 선택</label>
                            <div class="available-seats">
                                <c:forEach items="${availableSeats}" var="seat">
                                    <div class="seat-option" onclick="selectSeat(${seat.seatId})">
                                        <input type="radio" name="seatId" value="${seat.seatId}" id="seat_${seat.seatId}">
                                        <div style="font-weight: bold; font-size: 18px;">${seat.seatName}</div>
                                        <div style="font-size: 12px; color: #718096;">사용 가능</div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="hours" class="form-label">이용 시간</label>
                            <select name="hours" id="hours" class="form-select" required>
                                <option value="">시간을 선택해주세요</option>
                                <option value="1">1시간</option>
                                <option value="2">2시간</option>
                                <option value="3">3시간</option>
                                <option value="4">4시간</option>
                            </select>
                        </div>
                        
                        <button type="submit" class="submit-btn" id="submitBtn" disabled>
                            좌석 예약하기
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- 이용 안내 -->
        <div class="reservation-form">
            <h3>📋 예약 안내사항</h3>
            <ul style="color: #718096; line-height: 1.6;">
                <li>1인당 1개 좌석만 예약 가능합니다.</li>
                <li>최대 4시간까지 예약할 수 있습니다.</li>
                <li>예약 시간이 지나면 자동으로 예약이 해제됩니다.</li>
                <li>좌석을 사용하지 않을 경우 미리 예약을 취소해주세요.</li>
                <li>아두이노 센서로 실제 사용 여부를 확인합니다.</li>
            </ul>
        </div>
    </div>
    
    <script>
        let selectedSeatId = null;
        
        function selectSeat(seatId) {
            // 기존 선택 해제
            document.querySelectorAll('.seat-option').forEach(option => {
                option.classList.remove('selected');
            });
            
            // 새 선택 적용
            event.currentTarget.classList.add('selected');
            document.getElementById('seat_' + seatId).checked = true;
            selectedSeatId = seatId;
            
            // 버튼 상태 업데이트
            updateSubmitButton();
        }
        
        function updateSubmitButton() {
            const hoursSelected = document.getElementById('hours').value !== '';
            const seatSelected = selectedSeatId !== null;
            const submitBtn = document.getElementById('submitBtn');
            
            submitBtn.disabled = !(hoursSelected && seatSelected);
        }
        
        // 시간 선택 변경시 버튼 상태 업데이트
        document.getElementById('hours').addEventListener('change', updateSubmitButton);
        
        // 폼 제출시 확인
        document.getElementById('reservationForm').addEventListener('submit', function(e) {
            if (!selectedSeatId || !document.getElementById('hours').value) {
                e.preventDefault();
                alert('좌석과 이용시간을 모두 선택해주세요.');
                return false;
            }
            
            const seatName = document.querySelector('.seat-option.selected div').textContent;
            const hours = document.getElementById('hours').value;
            
            if (!confirm(`${seatName} 좌석을 ${hours}시간 예약하시겠습니까?`)) {
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>