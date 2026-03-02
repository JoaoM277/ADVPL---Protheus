#Include "totvs.ch"
#Include "fwmvcdef.ch"


/*/{Protheus.doc} BRWZZC
(long_description)
@type user function
@author user
@since 01/03/2026
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static cAliasMVC := "ZZC"
Static cTitulo := "Cantores"

User Function Z_CAN()
	
  Local aArea := GetArea()
	Local oBrowswZZC //Variavel Objeto que recebera o Instanciamento da classe FWMBrowse

	oBrowswZZC :=FWMBrowse():New()
	oBrowswZZC :SetAlias(cAliasMVC)
	oBrowswZZC :SetDescription(cTitulo)
  oBrowswZZC :Activate() 

  RestArea(aArea)

Return Nil

//MenuDef
Static Function MenuDef()
   Local aRotina := {} //Variavel de Rotina

   //Opções do Menu, Ex:
   ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.Z_CAN" OPERATION MODEL_OPERATION_VIEW ACCESS 0
   ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.Z_CAN" OPERATION MODEL_OPERATION_INSERT ACCESS 0
   ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.Z_CAN" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
   ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.Z_CAN" OPERATION MODEL_OPERATION_DELETE ACCESS 0

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
  oModel := MPFormModel():New("Z_CAN", bPre, bPos, bCommit, bCancel)
  oModel :AddFields("Z_CANSMST", /*cOwner*/, oStruct)
  oModel :SetDescription("Modelo de dados - " + cTitulo)
  oModel :GetModel("Z_CANSMST"):SetDescription( "Dados de - " + cTitulo)
  oModel :SetPrimaryKey({})
Return oModel

//ViewDef
Static Function ViewDef() 
    Local oModel := FWLoadModel("Z_CAN")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView

    //Cria a visualização do cadastro
    oView := FWFormView():New()
    oView :SetModel(oModel)
    oView :AddField("VIEW_Z_CAN", oStruct, "Z_CANSMST")
    oView :CreateHorizontalBox("TELA" , 50)
    oView :SetOwnerView("VIEW_Z_CAN", "TELA")

Return oView


