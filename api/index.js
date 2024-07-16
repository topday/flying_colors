const express = require('express');

const api = express();
api.use(express.json());
api.set('port', process.env.PORT || 3000);

//mock requests
api.get('/person', (req, res) => {
    res.send('Person data test ');
});

api.post('/order', (req, res) => {
    res.send('Person data test');
});

api.listen(api.get('port'), () => console.log('Mock API running... on port: ', api.get('port')));
