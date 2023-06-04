class Form extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      choices: [
        {
          name: 'Стажер C# разработчик',
          value: 'csharp-intern',
        },
        {
          name: 'Стажер Frontend разработчик',
          value: 'frontend-intern',
        },
        {
          name: '.NET Backend Junior Developer',
          value: '.net-junior',
        },
        {
          name: 'Fullstack Junior Developer',
          value: 'fullstack-junior',
        },
      ],
      selectedOption: null,
      file: null,
    };
  };

  onClick = (event) => {
    const value = event.target.value;
    this.setState({ ...this.state, selectedOption: value });
  }

  onSubmit = (event) => {
    event.preventDefault();
    if (!this.state.selectedOption) {
      alert('Вы не выбрали вакансию');
      return;
    }

    if (!this.state.file) {
      alert('Вы не загрузили свое резюме');
      return;
    }

    alert('Ваш выбор: ' + this.findOptionByValue(this.state.selectedOption).name);
  }

  handleFileUpload = (event) => {
    if (event.target.files) {
      this.setState({ ...this.state, file: event.target.files[0] });
    }
  }

  findOptionByValue = (value) => {
    return this.state.choices.find((choice) => choice.value === value);
  }

  render() {
    return (
      <form onSubmit={this.onSubmit}>
        {this.state.choices.map((choice, idx) => {
          return (
            <p key={idx}>
              <input type="radio" id={choice.value} value={choice.value} name="subject" onClick={this.onClick}/>
              <label htmlFor={choice.value}>{choice.name}</label>
            </p>);
        })}
        <div className="form-row">
          <p>Прикрепите свое резюме:</p>
        </div>
        <div className="form-row">
          <input type="file" name="file" onChange={this.handleFileUpload} />
        </div>
        <div className="form-row">
          <input type="submit" value="Отправить" />
        </div>
    </form>
    );
  }
}

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(<Form/>)
