import React, { Component } from 'react';
import './App.css';
import axios from 'axios';
import api from './API';
import BankAccount from './BankAccount';

class App extends Component {

  state = { bankAccounts: [], msg: "" }

  componentDidMount() {
    this.loadBankAccounts();
  }

  loadBankAccounts = () => {
    axios.get(api.action(''))
    .then((resp) => {
      this.setState({ bankAccounts: resp.data.bank_accounts });
    })
    .catch((error) => {
      console.log(error);
    });
  }

  openBankAccountHandler = () => {

    axios.post(api.action('open'))
    .then((resp) => {
      this.loadBankAccounts();
    })
    .catch((error) => {
      console.log(error);
    });

  }

  getBalanceHandler = () => {
    const account = this.refs.account.value.trim();
    if(account !== "") {
      axios.get(api.action(`balance/${account}`))
      .then((resp) => {
        if(resp.data.error) {
           this.setState({ msg: resp.data.error })
        }else{
           this.setState({ msg: `The Balance is: ${ resp.data.balance }` });
        }
      })
      .catch((error) => {
        console.log(error);
      });
    }
  }

  transferHandler = () => {

    const source = this.refs.source.value.trim();
    const destination = this.refs.destination.value.trim();
    const amount = this.refs.amount.value.trim();

    if(source !== "" &&
       destination !== "" &&
       amount !== "") {
      axios.put(api.action(`transfer/${source}/${destination}/${amount}`))
      .then((resp) => {
        if(resp.data.error) {
           this.setState({ msg: resp.data.error })
        }else{
           this.loadBankAccounts();
           this.setState({ msg: "Amount has been transferred!" });
        }
      })
      .catch((error) => {
        console.log(error);
      });
    }

  }

  render() {
    return (
      <div className="App">

        <header className="App-header">
          <h1 className="App-title"> Bank Accounts </h1>
        </header>

        <p className="msg"> { this.state.msg } </p>

        {this.state.bankAccounts.map((b,i) => (
          <BankAccount key={i} account_id={b.account_id} amount={b.amount} />
        ))}

        <hr />

        <button onClick={this.openBankAccountHandler}> New Bank Account </button>

        <h2>Transfer</h2>
        <label>From Account ID:</label><input ref="source" className="larger"></input> |
        <label>To Account ID:</label><input ref="destination" className="larger"></input> |
        <label>Amount:</label><input ref="amount"></input>
        <button onClick={this.transferHandler}> Ok </button>

        <h2>Get Balance</h2>
        <label>Account ID:</label><input ref="account" className="larger"></input>
        <button onClick={this.getBalanceHandler}> Ok </button>

      </div>
    );
  }
}

export default App;
