export default {
  action: (action) => {
    return `http://localhost:4000/api/v1/bank-accounts/${action}`;
  }
};
