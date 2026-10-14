const mysql = require("mysql2");
const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

const conexao = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "condominio"
});

conexao.connect(function(erro) {
    if (erro) {
        console.log("Erro ao conectar no banco.");
        console.log(erro);
    } else {
        console.log("Conectado ao banco do Condomínio com sucesso!");
    }
});

app.get("/apartamentos", function(req, res) {
    const select = "SELECT id, numero, bloco FROM apartamento";
    
    conexao.query(select, function (erroSelect, resultadoSelect) {
        if (erroSelect) {
            console.log("Erro ao consultar apartamentos.");
            return res.status(500).json(erroSelect);
        }
        res.json(resultadoSelect); 
    });
});

app.post("/apartamentos", function(req, res) {
    const numero = req.body.numero;
    const bloco = req.body.bloco;

    const insert = "INSERT INTO apartamento (numero, bloco) VALUES (?, ?)";
    
    conexao.query(insert, [numero, bloco], function (erro, resultado) {
        if (erro) {
            console.log("Erro ao cadastrar apartamento.");
            return res.status(500).json(erro);
        }
        res.json({ mensagem: "Apartamento cadastrado com sucesso!" });
    });
});

app.listen(3000, function() {
    console.log("Servidor rodando na porta 3000!");
});
