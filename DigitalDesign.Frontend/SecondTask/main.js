const url = 'https://www.cbr-xml-daily.ru/daily_json.js';
const button = document.getElementById('get-data');
const content = document.getElementById('content');

async function getData() {
    const response = await fetch(url);
    return await response.json();
}

async function parseData() {
    const data = await getData();
    const valutes = data["Valute"];
    console.log(valutes);
    for (const valute in valutes) {
        const newElement = document.createElement('div');
        if (valute === "USD" || valute === "EUR") {
            newElement.innerHTML = `${valutes[valute]["Name"]}:  ${valutes[valute]["Value"]} рублей`;
            content.append(newElement)
        }
    }
}

async function onClick() {
    button.removeEventListener('click', onClick);
    const data = await getData();
    await parseData(data);
}

button.addEventListener('click', onClick);
