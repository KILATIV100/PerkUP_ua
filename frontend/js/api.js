const button = document.querySelector('#checkApiBtn');
const result = document.querySelector('#apiResult');

const API_BASE_URL =
  window.PERKUP_API_URL || 'https://perkupua-production.up.railway.app';

const fetchHealth = async () => {
  result.textContent = 'Завантаження...';

  try {
    const response = await fetch(`${API_BASE_URL}/health`);

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();
    result.textContent = JSON.stringify(data, null, 2);
  } catch (error) {
    result.textContent = `Помилка: ${error.message}`;
  }
};

button?.addEventListener('click', fetchHealth);
