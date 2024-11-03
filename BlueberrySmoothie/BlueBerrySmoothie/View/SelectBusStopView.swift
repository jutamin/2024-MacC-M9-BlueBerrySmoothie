//
//  SelectBusStopView.swift
//  BlueBerrySmoothie
//
//  Created by Yeji Seo on 10/31/24.
//

import SwiftUI

struct SelectBusStopView: View {
    @EnvironmentObject var busStopViewModel: BusStopViewModel
    
    let city: City // 도시 정보
    let bus: Bus
//    @State private var busStops: [BusStop] = [] // 버스 목록을 저장하는 상태 변수
    //    @State private var routeNo: String = "" // 입력된 노선 번호를 저장하는 상태 변수
    
    var body: some View {
        VStack(spacing: 20) {
            Text("도시 이름: \(city.cityname)")
            Text("도시 코드: \(city.citycode)")
                .foregroundColor(.gray)
            Text("버스 번호: \(bus.routeno)")
                .foregroundColor(.gray)
            Text("노선 ID: \(bus.routeid)")
                .foregroundColor(.gray)
            
            Text("상행:0 ,하행:1")
            List {
                ForEach(busStopViewModel.busStopList, id: \.self) { busStop in
                    VStack(alignment: .leading) {
                        Text("정류소ID: \(busStop.nodeid)")
                        Text("정류소명: \(busStop.nodenm)")
                        Text("정류소번호: \(busStop.nodeno ?? 0)")
                        Text("정류소순번: \(busStop.nodeord)")
                        Text("x,y 좌표: \(busStop.gpslati), \(busStop.gpslong)")
                        Text("상하행구분코드: \(busStop.updowncd)")
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding()
        .navigationTitle("버스정류장들 정보")
        .onAppear{
            Task{
                await busStopViewModel.getBusStopData(cityCode: city.citycode, routeId: bus.routeid)
            }
        }
    }
}

