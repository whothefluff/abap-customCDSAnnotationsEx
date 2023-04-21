@AbapCatalog.sqlViewName: 'ZICCADefaultData'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Some data with custom CDS annotations'
define view ZI_CCA_DefaultData
  as select from I_UnitOfMeasure
  {
    UnitOfMeasure,
    UnitOfMeasureDimension,
    @zDefaultValue: '999'
    UnitOfMeasureISOCode,
    UnitOfMeasureNumberOfDecimals,
    UnitOfMeasureDspNmbrOfDcmls,
    UnitOfMeasure_E,
    _Dimension,
    _DimensionText,
    _Text
  }
