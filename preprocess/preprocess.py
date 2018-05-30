"""
Author : Sebastien Boyer
Pre-processing database before feature extraction
"""
from __future__ import print_function
from processor.processor import open_sql_connection, run_sql_script, \
    close_sql_connection, run_python_script


def preprocess(cfg_mysql, cfg_pipeline, cfg_course, cfg_mysql_script_path):
    db_name = cfg_mysql['database']
    current_date = cfg_course['current_date']
    script_dir = cfg_mysql_script_path['preprocess_dir']
    import_dir = cfg_mysql_script_path['MLQ_dir']
    timeout = cfg_pipeline['timeout']
    start_date = cfg_course['start_date']
    num_weeks = cfg_course['number_of_weeks']

    scripts = [
        (
            'create_feature_info_table.sql',
            ['moocdb'],
            [db_name]
        ),
        (
            'create_user_dropout_table.sql',
            ['moocdb'],
            [db_name]
        ),
        (
            'create_feature_table.sql',
            ['moocdb'],
            [db_name]
        ),
        (
            'create_long_feature_table.sql',
            ['moocdb'],
            [db_name]
        ),
        (
            'create_user_feature_table.sql',
            ['moocdb'],
            [db_name]
        ),
        (
            'create_video_feature_table.sql',
            ['moocdb'],
            [db_name]
        ),
        (
            'create_user_long_feature_table.sql',
            ['moocdb'],
            [db_name]
        ),
        (
            'create_video_long_feature_table.sql',
            ['moocdb'],
            [db_name]
        ),
        (
            'create_user_video_feature_table.sql',
            ['moocdb'],
            [db_name]
        ),
        # Population scripts
        (
            'populate_feature_info_table.py',
            ['moocdb'],
            [db_name]
        ),
        (
            'populate_user_dropout_table.sql',
            ['moocdb'],
            [db_name]
        ),
        # Create and populate feature table bases
        (
            'create_and_populate_long_feature_base.sql',
            ['moocdb'],
            [db_name]
        ),
        (
            'create_and_populate_user_long_feature_base.sql',
            ['moocdb'],
            [db_name]
        ),
    ]
    conn = open_sql_connection(cfg_mysql)

    for script_name, to_be_replaced, replace_by in scripts:
        if script_name[-3:] == '.py':
            run_python_script(script_name=script_name,
                              script_dir=script_dir,
                              conn=conn,
                              conn2=None,
                              import_dir=import_dir,
                              db_name=db_name,
                              start_date=start_date,
                              current_date=current_date,
                              num_weeks=num_weeks,
                              timeout=timeout)
        elif script_name[-4:] == '.sql':
            script_path = script_dir + '/' + script_name
            run_sql_script(conn=conn,
                           script_path=script_path,
                           to_be_replaced=to_be_replaced,
                           replace_by=replace_by,
                           timeout=timeout)

        conn.commit()

    close_sql_connection(conn)
