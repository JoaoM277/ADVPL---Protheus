//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVDef.ch"

//Variaveis Estaticas
Static cTitulo := ""
Static cAliasMVC := ""

/*/{Protheus.doc} MVC01
(long_description)
@type user function
@author user
@since 28/02/2026
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function zMVC01()
  Local aArea := GetArea()
  Local oBrowse 
  Private aRotina := {}

  //Definicao do menu
  aRotina := MenuDef()

  //Instalando a Browse
  oBrowse := FWMBrouse():New()
  oBrowse := SetAlias(cAliasMVC)
  oBrowse := SetDescription(cTitulo)
  oBrowse := DisableDetails()

  //Ativa a Browse
  oBrowse:Activate()

  RestArea(aArea)
Return NIL

//MenuDef
Static Function MenuDef()
   Local aRotina := {} //Variavel de Rotina

   //Opções do Menu, Ex:
   ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDE.zMVC01" OPERATION 1 ACESS 0
   ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDE.zMVC01" OPERATION 3 ACESS 0
   ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDE.zMVC01" OPERATION 4 ACESS 0
   ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDE.zMVC01" OPERATION 5 ACESS 0

Return aRotina
//ModelDef
Static Function ModelDef()
  Local oStruct := FWFormStruct(1, cAliasMVC)
  Local oModel
  Local bPre := Nil
  Local bPos := Nil
  Local bCommit := Nil
  Local bCancel := Nil

  //Cria o modelo de dados para o cadastro
  oModel := MPFormModel():New("zMVC01M", bPre, bPos, bCommit, bCancel)
  oModel :AddFields("ZD1MASTER", /*cOwner*/, oStruct)
  oModel :SetDescription("Modelo de dados - " + cTitulo)
  oModel :GetModel("ZD1MASTER"):SetDescription( "Dados de - " + cTitulo)
  oModel :SetPrimaryKey({})
Return oModel
//ViewDef
Static Function ViewDef() 
    Local oModel := FWLoadModel("zMVC01")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView

    //Cria a visualização do cadastro
    oView := FWFormView():New()
    oView :SetModel(oModel)
    oView :AddField("VIEW_ZD1", oStruct, "ZD1MASTER")
    oView :CreateHorizontalBox("TELA" , 100)
    oView :SetOwnerView("VIEW_ZD1", "TELA")

Return oView
//MarkBrowsw
User Function zMVC05()
  Private oMark

  //Criando o MarkBrow
  oMark :=FWMarkBrowse():New()
  oMark :SetAlias('ZD1')

  //Setando semaforo, descrição e campo de mark
  oMark:SetSemaphore(.T.)
  oMark:SetDescription('Seleção do Cadastro de Artistas')
  oMark:SetFieldmark('ZD1_OK')

  //Ativando a janela
  oMark:Activate()
Return NIL
    
 


