var express = require('express');
var graphqlHTTP = require('express-graphql');
// var { graphql, buildSchema } = require('graphql');
var { buildSchema } = require('graphql');

// Construct a schema, using GraphQL schema language
var schema = buildSchema(`
  type Author {
    id: ID
    firstname: String
    lastname: String
  }

  type Journal {
    id: ID
    name: String
  }

  type Publication {
    id: ID
    title: String
    journal: Journal
    authors: [Author]
  }

  type Query {
    author(id: ID, firstname: String): Author
    journal(id: ID, name: String): Journal
  }
`);

// Maps id to User object
var fakeJournals = {
  'itk': {
    id: '1',
    name: 'itk',
  },
  'vtk': {
    id: '2',
    name: 'vtk',
  }
};

// The root provides a resolver function for each API endpoint
// var root = { publication: () => 'Hello world!' };
var root = {
  // author: function ({id}) {
  //   return fakeDatabase[id];
  // },
  journal: function ({name}) {
    return fakeJournals[name];
  }
};

// Just with: npm install graphql
// Run the GraphQL query '{ hello }' and print out the response
// graphql(schema, '{ hello }', root).then((response) => {
//   console.log(response);
// });
// with: npm  install graphql express express-graphql
var app = express();
app.set('port', (3000));
app.listen(app.get('port'), () => {
  console.log('Now browse to localhost:' + app.get('port') + '/graphql')
});
app.use('/graphql', graphqlHTTP({
  schema: schema,
  rootValue: root,
  graphiql: true,
}));
