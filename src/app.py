import dash
import dash_core_components as dcc
import dash_html_components as html
import os
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

data = pd.DataFrame({'measure_1': [10, 5, 8, 4],
                     'group_1': ['a', 'b'] * 2,
                     'group_2': ['c'] * 2 + ['d'] * 2})

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
app.layout = html.Div([
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
    )
])


@app.callback(
    dash.dependencies.Output('bar-graph', 'figure'),
    [dash.dependencies.Input('bar-type', 'value')])
def bar(bar_value):
    fig = px.bar(data, x='group_1', y='measure_1', color='group_2', barmode=bar_value)
    return fig


if __name__ == '__main__':
    app.run_server(host='0.0.0.0', debug=True, port=8050)
