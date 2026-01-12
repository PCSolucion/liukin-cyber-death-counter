const countEl = document.getElementById('count');
// Target the main container for border flashes
const hudPanel = document.querySelector('.hud-panel');
let currentCount = -1;

function fetchCount() {
    fetch('http://localhost:3000/api/count')
        .then(response => response.json())
        .then(data => {
            if (data.count !== currentCount) {
                const firstLoad = currentCount === -1;
                currentCount = data.count;

                countEl.innerText = currentCount;

                if (!firstLoad) {
                    // Flash effect on update
                    hudPanel.classList.remove('damage-flash');
                    void hudPanel.offsetWidth; // Force reflow
                    hudPanel.classList.add('damage-flash');
                }
            }
        })
        .catch(err => console.error('Error polling count:', err));
}

setInterval(fetchCount, 500);
fetchCount();
