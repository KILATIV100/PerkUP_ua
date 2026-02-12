const button = document.querySelector('#checkApiBtn');
const result = document.querySelector('#apiResult');

const fetchHealth = async () => {
  result.textContent = 'Завантаження...';

  try {
    const response = await fetch('http://localhost:3000/health');

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
