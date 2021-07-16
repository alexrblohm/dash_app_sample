import dash
import dash_core_components as dcc
import dash_html_components as html
from dash_table import DataTable, FormatTemplate
import os
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

from foodcast.aws import AwsConn

AWS = AwsConn('ia-forecasting')

data = pd.DataFrame({'measure_1': [12, 5, 8, 4],
                     'group_1': ['a', 'b'] * 2,
                     'group_2': ['c'] * 2 + ['d'] * 2})

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
app.layout = html.Div([
    dcc.Dropdown(
        id='group',
        options=[{'label': ele, 'value': ele} for ele in data['group_1'].unique()]
    ),
    dcc.RadioItems(
        id='bar-type',
        options=[
            {'label': 'Side-by-side Bar Graph', 'value': 'group'},
            {'label': 'Over-layed Bar Graph', 'value': 'overlay'}
        ],
        value='group'
    ),
    dcc.Graph(
        id='bar-graph'
    ),
    DataTable(
        id='table',
        columns=[dict(id=i, name=i, type='numeric') for i in data.columns],
        editable=True
    ),
dcc.ConfirmDialogProvider(
        children=html.Button('Save Adjustment'),
        id='submit_button',
        message='Are you sure you want to save your Forecast adjustment?'
    ),
    html.Div(id='output-provider')
])


@app.callback(
    dash.dependencies.Output('bar-graph', 'figure'),
    [dash.dependencies.Input('bar-type', 'value')])
def bar(bar_value):
    fig = px.bar(data, x='group_1', y='measure_1', color='group_2', barmode=bar_value)
    return fig


@app.callback(
    dash.dependencies.Output('table', 'data'),
    [dash.dependencies.Input('group', 'value')]
)
def update_table(group_val):
    data2 = data.copy()
    if group_val:
        data2 = data2.groupby('group_1').sum().reset_index()
    return data2.to_dict('records')


@app.callback(
    dash.dependencies.Output('output-provider', 'children'),
    [dash.dependencies.Input('submit_button', 'submit_n_clicks')],
    [dash.dependencies.State('table', 'data'),
     dash.dependencies.State('table', 'columns')])
def update_output(submit_n_clicks, data, columns):
    if submit_n_clicks:
        df = pd.DataFrame(data, columns=[c['name'] for c in columns])
        AWS.put_object_to_s3(df, key='test.csv')
        return f"Forecast adjustments were saved! Sent {submit_n_clicks} times."

if __name__ == '__main__':
    app.run_server(host='0.0.0.0', debug=True, port=8050)
