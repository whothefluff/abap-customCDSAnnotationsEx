@AbapCatalog.sqlViewName: 'ZICCASomedata'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Some data with custom CDS annotations'
@zDefaultClauses: {
  fieldList: [
    'UnitOfMeasure as ID,',
    'UnitOfMeasureISOCode as ISOCode'
  ],
  conditions: [ 'UnitOfMeasureDimension ne \'SPEED\' ',
                'and UnitOfMeasureNumberOfDecimals ne 0 ' ]
//  grouping: [ '' ],
//  groupCond: [ '' ],
//  sorting: [ '' ]
}
define view ZI_CCA_SomeData
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
    _Text
  }
