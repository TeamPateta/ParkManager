﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace Teste
{
    public partial class FrmTelaEstacionamento : Form
    {
        Banco banco = new Banco();
        public FrmTelaEstacionamento()
        {
            InitializeComponent();
        }

        private void FrmTelaEstacionamento_Load(object sender, EventArgs e)
        {
            CarregarIdentificacao();
            panel4.VerticalScroll.Value = 0;
        }
        private void CarregarIdentificacao()
        {
            DataTable dt = new DataTable();
            try
            {
                List<SqlParameter> sp = new List<SqlParameter>()
                {
                    new SqlParameter(){ParameterName = "@Flag", SqlDbType = SqlDbType.Int, Value = 8}
                };
                dt = banco.InsertData("dbo.Funcoes_Pesquisa",sp);
                if(dt.Rows.Count > 0)
                {
                    PreencherCampos(dt);
                }
            }
            catch (Exception ex)
            {

                MessageBox.Show(ex.Message, "Falha ao carregar a identificação!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        private void PreencherCampos(DataTable dt)
        {
            txtRazaoSocial.Text = dt.Rows[0].ItemArray[1].ToString();
            mskCnpj.Text = dt.Rows[0].ItemArray[0].ToString();
            mskInscricao.Text = dt.Rows[0].ItemArray[8].ToString();
            mskTelefone.Text = dt.Rows[0].ItemArray[9].ToString();
            mskCEP.Text = dt.Rows[0].ItemArray[7].ToString();
            txtNumero.Text = dt.Rows[0].ItemArray[4].ToString();
            txtEndereco.Text = dt.Rows[0].ItemArray[2].ToString();
            txtBairro.Text = dt.Rows[0].ItemArray[3].ToString();
            txtCidade.Text = dt.Rows[0].ItemArray[5].ToString();
            txtEstado.Text = dt.Rows[0].ItemArray[6].ToString();
        }

        private void btnEditar_Click(object sender, EventArgs e)
        {
            AtivarCaixas();
        }
        private void AtivarCaixas()
        {
            btnSalvar.Enabled = true;
            txtRazaoSocial.Enabled = true;
            mskCnpj.Enabled = true;
            mskInscricao.Enabled = true;
            mskTelefone.Enabled = true;
            mskCEP.Enabled = true;
            txtNumero.Enabled = true;
            txtEndereco.Enabled = true;
            txtBairro.Enabled = true;
            txtCidade.Enabled = true;
            txtEstado.Enabled = true;
        }

        private void txtNumero_KeyPress(object sender, KeyPressEventArgs e)
        {
            //Apenas Números
            if (!char.IsNumber(e.KeyChar) && !Char.IsControl(e.KeyChar) && !(e.KeyChar == (char)Keys.Back))
            {
                e.Handled = true;
            }
        }

        private void txtEstado_KeyPress(object sender, KeyPressEventArgs e)
        {
            //Apenas Letras
            if (!char.IsLetter(e.KeyChar) && !(e.KeyChar == (char)Keys.Back))
            {
                e.Handled = true;
            }
        }

        private void txtCidade_KeyPress(object sender, KeyPressEventArgs e)
        {
            //Apenas Letras
            if (!char.IsLetter(e.KeyChar) && !(e.KeyChar == (char)Keys.Back))
            {
                e.Handled = true;
            }
        }

        private void btnSalvar_Click(object sender, EventArgs e)
        {
            VerificarCaixas();
        }
        private void VerificarCaixas()
        {
            // If que verifica se todas as caixas estão preenchidas
            if(txtRazaoSocial.Text =="" || mskCnpj.Text == "" || mskInscricao.Text == "" || mskTelefone.Text == "" || mskCEP.Text == "" || txtNumero.Text == "" || txtEndereco.Text == "" || txtBairro.Text == "" || txtCidade.Text == "" || txtEstado.Text == "")
            {
                MessageBox.Show("Preencha todos os campos!", "Falha ao Salvar!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
            {
                if(Regex.IsMatch(mskCnpj.Text, @"^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$"))
                {
                    if(Regex.IsMatch(mskInscricao.Text, @"/^\d{3}\.\d{3}\.\d{3}\.\d{3}/"))
                    {
                        if(Regex.IsMatch(mskTelefone.Text, @"/^\([11 - 99]{2}\)[0 | 9]\d{4}\-\d{4}/"))
                        {
                            if(Regex.IsMatch(mskCEP.Text, @"/\d{5}\-\d{3}/"))
                            {
                                if(Regex.IsMatch(txtNumero.Text, @"/\d+/"))
                                {
                                    if(Regex.IsMatch(txtCidade.Text, @"/\D+/"))
                                    {
                                        SalvarIdentificacao();
                                    }
                                    else
                                    {
                                        MessageBox.Show("Cidade Inválida!", "Falha ao Salvar!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                    }
                                    
                                }
                                else
                                {
                                    MessageBox.Show("Número Inválido!", "Falha ao Salvar!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                }
                            }
                            else
                            {
                                MessageBox.Show("CEP Inválido!", "Falha ao Salvar!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            }
                        }
                        else
                        {
                            MessageBox.Show("Telefone Inválido!", "Falha ao Salvar!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        }
                    }
                    else
                    {
                        MessageBox.Show("Inscrição Estadual Inválida!", "Falha ao Salvar!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
                else
                {
                    MessageBox.Show("CNPJ Inválido!", "Falha ao Salvar!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
        private void SalvarIdentificacao()
        {
            try
            {
                int LinhasAfetadas = 0;
                List<SqlParameter> sp = new List<SqlParameter>()
                {
                    new SqlParameter(){ParameterName = "@Flag", SqlDbType = SqlDbType.Int, Value =2},
                    new SqlParameter(){ParameterName = "@Cnpj", SqlDbType = SqlDbType.VarChar, Value = mskCnpj.Text},
                    new SqlParameter(){ParameterName = "@Razao_Social", SqlDbType = SqlDbType.VarChar, Value = txtRazaoSocial.Text},
                    new SqlParameter(){ParameterName = "@Endereco", SqlDbType = SqlDbType.VarChar, Value = txtEndereco.Text},
                    new SqlParameter(){ParameterName = "@Bairro", SqlDbType = SqlDbType.VarChar, Value = txtBairro.Text},
                    new SqlParameter(){ParameterName = "@Numero", SqlDbType = SqlDbType.Int, Value = txtNumero.Text},
                    new SqlParameter(){ParameterName = "@Cidade", SqlDbType = SqlDbType.VarChar, Value = txtCidade.Text},
                    new SqlParameter(){ParameterName = "@Estado", SqlDbType = SqlDbType.Char, Value = txtEstado.Text},
                    new SqlParameter(){ParameterName = "@Cep", SqlDbType = SqlDbType.Char, Value = mskCEP.Text},
                    new SqlParameter(){ParameterName = "@Inscricao_Estadual", SqlDbType = SqlDbType.VarChar, Value = mskInscricao.Text },
                    new SqlParameter(){ParameterName = "@Telefone", SqlDbType = SqlDbType.VarChar, Value = mskTelefone.Text}
                };
                LinhasAfetadas = banco.EditData("dbo.Parametros", sp);
                if(LinhasAfetadas > 0)
                {
                    DesativarCaixas();
                    btnEditar.Enabled = true;
                    MessageBox.Show("Alterações Salvas com Sucesso!", "Salvamento Concluído!", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show("Falha ao Salvar as alterações!", "Falha ao Salvar!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {

                MessageBox.Show(ex.Message, "Falha ao Salvar!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        private void DesativarCaixas()
        {
            btnSalvar.Enabled = false;
            txtRazaoSocial.Enabled = false;
            mskCnpj.Enabled = false;
            mskInscricao.Enabled = false;
            mskTelefone.Enabled = false;
            mskCEP.Enabled = false;
            txtNumero.Enabled = false;
            txtEndereco.Enabled = false;
            txtBairro.Enabled = false;
            txtCidade.Enabled = false;
            txtEstado.Enabled = false;
        }

        private void txtRazaoSocial_TextChanged(object sender, EventArgs e)
        {

        }

        private void txtEndereco_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
