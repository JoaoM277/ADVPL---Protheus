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

User Function BRWZZC()
	Local aArea := GetNextAlias()
	Local oBrowswZZC //Variavel Objeto que recebera o Instanciamento da classe FWMBrowse

	oBrowswZZC :=FWMBrowse():New()
	oBrowswZZC :SetAlias("ZZC")
	oBrowswZZC :SetDescription("Cadastro de Cantores")
    oBrowswZZC :Activate() 

Return


