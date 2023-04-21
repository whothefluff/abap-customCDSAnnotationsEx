@AbapCatalog.sqlViewName: 'ZICCASomedataWPA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Params with custom CDS annotations'
define view ZI_CCA_SomeDataWParams
  with parameters
    @zDefaultValue: 'E'
    Language : abap.lang
  as select from I_UnitOfMeasure
  {
    UnitOfMeasure,
    UnitOfMeasureDimension,
    UnitOfMeasureISOCode,
    UnitOfMeasureNumberOfDecimals,
    UnitOfMeasureDspNmbrOfDcmls,
    UnitOfMeasure_E,
    _Dimension,
    _DimensionText,
    $parameters.Language as ChosenLanguage,
    _Text[ 1:_Text.Language = $parameters.Language ]
  }
