"! <p class="shorttext synchronized" lang="en">Custom CDS annotations processing examples</p>
class zcl_cca_processing_examples definition
                                  public
                                  create public.

  public section.

    interfaces: if_oo_adt_classrun.

    types t_ZI_CCA_DefaultData type standard table of ZI_CCA_DefaultData with empty key.

    types t_ZI_CCA_SomeData type standard table of ZI_CCA_SomeData with empty key.

    types t_ZI_CCA_SomeDataWParams type standard table of I_UnitOfMeasureText with empty key.

    types t_entities_with_cust_annot type standard table of string with empty key.

    "! <p class="shorttext synchronized" lang="en">Returns processed ZI_CCA_DefaultData</p>
    "! Returns the result of querying an entity and using annotation <em>zDefaultValue</em>
    "! to provide a default value for all annotated empty elements.
    "!
    "! @parameter r_ZI_CCA_DefaultData | <p class="shorttext synchronized" lang="en"></p>
    methods read_ZI_CCA_DefaultData
              returning
                value(r_ZI_CCA_DefaultData) type zcl_cca_processing_examples=>t_ZI_CCA_DefaultData.

    "! <p class="shorttext synchronized" lang="en">Returns processed ZI_CCA_SomeData</p>
    "! Returns the result of querying an entity using dynamic syntax specified in the entity itself.
    "! <br/>
    "! The result of the query is saved in an itab with dynamic type
    "!
    "! @parameter r_ZI_CCA_SomeData | <p class="shorttext synchronized" lang="en"></p>
    methods read_ZI_CCA_SomeData
              returning
                value(r_ZI_CCA_SomeData) type zcl_cca_processing_examples=>t_ZI_CCA_SomeData.

    "! <p class="shorttext synchronized" lang="en">Returns processed ZI_CCA_SomeDataWParams</p>
    "! Returns the result of querying an entity with a parameter.
    "! <br/>
    "! The value of the parameter comes from an annotation in the parameter itself.
    "!
    "! @parameter i_language | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_ZI_CCA_SomeDataWParams | <p class="shorttext synchronized" lang="en"></p>
    methods read_ZI_CCA_SomeDataWParams
              importing
                i_language type langu optional
              returning
                value(r_ZI_CCA_SomeDataWParams) type zcl_cca_processing_examples=>t_ZI_CCA_SomeDataWParams.

    "! <p class="shorttext synchronized" lang="en">Returns annotated entities</p>
    "! This method queries all entities in the system with annotation <em>zGroup1</em>.
    "!
    "! @parameter r_entities_with_cust_annot | <p class="shorttext synchronized" lang="en"></p>
    methods get_entities_with_cust_annot
              returning
                value(r_entities_with_cust_annot) type zcl_cca_processing_examples=>t_entities_with_cust_annot.

  protected section.

endclass.



class zcl_cca_processing_examples implementation.

  method if_oo_adt_classrun~main.

    "use cases
    "  get a list of entities that share an annotation
    "  provide extra info for an element or a parameter (default values, etc.)
    "  provide extra info for an entity (default query, etc.)

    try.

*      out->write( me->read_ZI_CCA_SomeDataWParams( ) ).

*      out->write( me->get_entities_with_cust_annot( ) ).

*      out->write( me->read_ZI_CCA_DefaultData( ) ).

      out->write( me->read_ZI_CCA_SomeData( ) ).

    catch cx_root into data(error) ##CATCH_ALL.

      out->write( error->get_text( ) ).

    endtry.

  endmethod.
  method read_ZI_CCA_SomeData.

    types default_field_list type standard table of string with empty key.

    types elements_of_default_field_list type hashed table of string with unique key table_line.

    constants entity_name type ddstrucobjname value 'ZI_CCA_SomeData'.

    field-symbols <generic_itab> type any table.

    data generic_ref type ref to data.

*    cl_dd_ddl_annotation_service=>get_direct_annos_4_entity( exporting entityname = entity_name
*                                                             importing annos = data(annotations) ). "not easy to work with objects and arrays, but cool for simple annotations

    cl_dd_ddl_annotation_service=>get_direct_annoval_4_entity( exporting entityname = entity_name
                                                                         annoname = to_upper( `zDefaultClauses.fieldList` )
                                                                         array_anno = abap_true
                                                               importing values = data(annot_field_list) ).

    data(default_field_list) = value default_field_list( for <field> in annot_field_list
                                                         let length_minus_fst_n_last_chars = strlen( <field> ) - 2 in
                                                         ( conv #( <field>+1(length_minus_fst_n_last_chars) ) ) ).

    cl_dd_ddl_annotation_service=>get_direct_annoval_4_entity( exporting entityname = entity_name
                                                                         annoname = to_upper( `zDefaultClauses.conditions` )
                                                                         array_anno = abap_true
                                                               importing values = data(annot_conditions) ).

    data(default_conditions) = value string_table( for <cond> in annot_conditions
                                                   let length_minus_fst_n_last_chars = strlen( <cond> ) - 2 in
                                                   ( replace( val = <cond>+1(length_minus_fst_n_last_chars)
                                                              sub = `\`
                                                              with = ``
                                                              occ = 0 ) ) ).

    data(entity_line_type) = cast cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( entity_name ) ).

    data(elements_of_default_field_list) = value elements_of_default_field_list( for <default_field> in default_field_list
                                                                                 ( to_upper( segment( val = <default_field>
                                                                                                      index = 1
                                                                                                      space = ` ` ) ) ) ).

    data(entity_default_fields_type) = cl_abap_structdescr=>get( filter #( entity_line_type->get_components( ) in elements_of_default_field_list where name eq table_line ) ).

    data(entity_itab_type) = cl_abap_tabledescr=>get( entity_default_fields_type ).

    create data generic_ref type handle entity_itab_type.

    assign generic_ref->* to <generic_itab>.

    select (default_field_list)
      from (entity_name)
      where (default_conditions)
      into table @<generic_itab>.

    r_ZI_CCA_SomeData = corresponding #( <generic_itab> ).

  endmethod.
  method read_ZI_CCA_SomeDataWParams.

    constants entity_name type ddstrucobjname value 'ZI_CCA_SomeDataWParams'.

    cl_dd_ddl_annotation_service=>get_direct_annos_4_parameter( exporting entityname = entity_name
                                                                          parametername = 'Language' ##NO_TEXT
                                                                importing annos = data(param_annotations) ).

    data(default_language) = param_annotations[ annoname = conv #( to_upper( 'zDefaultValue' ) ) ]-value+1(1).

    select \_Text-Language as language,
           \_Text-UnitOfMeasure as id,
           \_Text-UnitOfMeasureLongName as long_name,
           \_Text-UnitOfMeasureName as short_name,
           \_Text-UnitOfMeasureTechnicalName as tech_name,
           \_Text-UnitOfMeasure_E as ext_name
      from ZI_CCA_SomeDataWParams( language = @default_language )
      where UnitOfMeasure eq 'KM'
      into table @r_ZI_CCA_SomeDataWParams.

  endmethod.
  method get_entities_with_cust_annot.

    field-symbols <generic_itab> type any table.

    data generic_ref type ref to data.

    cl_dd_ddl_annotation_service=>get_entities_4_anno( exporting annoname = 'zGroup1'
                                                       importing entitynames = data(entity_names) ).

    data(entities_with_cust_annot) = value zcl_cca_processing_examples=>t_entities_with_cust_annot( ).

    loop at entity_names reference into data(entity_name).

      data(entity_itab_type) = cl_abap_tabledescr=>get( cast #( cl_abap_typedescr=>describe_by_name( entity_name->* ) ) ).

      create data generic_ref type handle entity_itab_type.

      assign generic_ref->* to <generic_itab>.

      select *
        from (entity_name->*)
        into table @<generic_itab>.

      if <generic_itab> is not initial.

        entities_with_cust_annot = value #( base entities_with_cust_annot
                                            ( conv #( entity_name->* ) ) ).

      endif.

    endloop.

    r_entities_with_cust_annot = entities_with_cust_annot.

  endmethod.
  method read_ZI_CCA_DefaultData.

    constants entity_name type ddstrucobjname value 'ZI_CCA_DefaultData'.

    cl_dd_ddl_annotation_service=>get_drct_annos_4_entity_elmnts( exporting entityname = entity_name
                                                                            extend = abap_true
                                                                  importing annos = data(annotations) ).



    select *
      from ZI_CCA_DefaultData
      into table @data(data_with_custom_annot_aux).

    data(data_with_custom_annot) = data_with_custom_annot_aux.

    loop at data_with_custom_annot reference into data(line_with_custom_annot).

      loop at annotations reference into data(annot_default_value) where annoname eq to_upper( 'zDefaultValue' ).

        assign component annot_default_value->*-elementname of structure line_with_custom_annot->* to field-symbol(<element>).

        if sy-subrc eq 0
           and <element> is initial.

          <element> = exact #( cond ddannotation_val( when annot_default_value->*-value(1) eq ''''
                                                      then let length_minus_fst_n_last_chars = strlen( annot_default_value->*-value ) - 2 in
                                                           annot_default_value->*-value+1(length_minus_fst_n_last_chars)
                                                      else annot_default_value->*-value ) ).

        endif.

      endloop.

    endloop.

    r_ZI_CCA_DefaultData = data_with_custom_annot.

  endmethod.

endclass.
