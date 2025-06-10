// main.js
document.addEventListener('DOMContentLoaded', function() {
    // 메뉴 아이템 클릭 애니메이션
    document.querySelectorAll('.menu-item').forEach(item => {
        item.addEventListener('click', function(e) {
            // 클릭 효과
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = '';
            }, 150);
        });
    });

    // 실시간 시간 업데이트 (선택사항)
    function updateTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('ko-KR');
        console.log('현재 시간:', timeString);
    }
    
    setInterval(updateTime, 60000); // 1분마다 업데이트

    // 좌석 현황 실시간 업데이트 시뮬레이션 (나중에 실제 API로 대체)
    function updateSeatStatus() {
        const availableElement = document.querySelector('.available');
        const occupiedElement = document.querySelector('.occupied');
        
        if (availableElement && occupiedElement) {
            // 임시 데이터 (나중에 실제 API 호출로 변경)
            const totalSeats = 40;
            const occupiedSeats = Math.floor(Math.random() * 20) + 10;
            const availableSeats = totalSeats - occupiedSeats;
            
            availableElement.textContent = availableSeats + '석';
            occupiedElement.textContent = occupiedSeats + '석';
        }
    }
    
    // 30초마다 좌석 현황 업데이트 (개발 단계에서는 주석 처리)
    // setInterval(updateSeatStatus, 30000);
});