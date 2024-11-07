//
//  alertSettingMain.swift
//  BlueBerrySmoothie
//
//  Created by 문호 on 11/1/24.
//

import SwiftUI
import SwiftData

// AlertSettingMain 뷰
struct AlertSettingMain: View {
    @Environment(\.modelContext) private var modelContext // ModelContext를 가져옴
    @State private var isFirstViewActive = false // 뷰이동
    
    @Environment(\.dismiss) private var dismiss
    
    @Query var busStopLocal: [BusStopLocal]
    @State private var label: String = ""
    @State private var showSheet: Bool = false
    @State private var selectedStation: String = "정류장 수"
    
    @State private var busStopAlert: BusStopAlert?
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text("알람 설정")
                            .font(.medium24)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    HStack {
                        Text("종착지에 도착하기 전에 깨워드려요")
                            .font(.regular16)
                            .foregroundColor(Color.gray3)
                        Spacer()
                    }
                    .padding(.bottom, 36)
                    
                    VStack {
                        HStack(spacing: 2) {
                            Text("버스 및 종착지")
                                .foregroundColor(.black)
                                .font(.regular16)
                            Image(systemName: "asterisk")
                                .foregroundColor(Color.brand)
                                .font(.regular10)
                                .bold()
                                .padding(.trailing)
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color.gray6)
                                    .cornerRadius(8)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray4, lineWidth: 1)
                                    }
                                HStack {
                                    Text(busStopAlert?.bus.routeno ?? "선택 안됨")  // 선택된 버스 표시
                                        .font(.regular16)
                                        .foregroundColor(Color.black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 10)
                                    Spacer()
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                            Spacer()
                            
                            NavigationLink(destination: SelectBusView( busStopAlert: $busStopAlert, isFirstViewActive: $isFirstViewActive), isActive: $isFirstViewActive) {  // 선택된 버스를 전달받음
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color.lightbrand)
                                        .cornerRadius(20)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.brand, lineWidth: 1)
                                        }
                                    Text("버스 찾기")
                                        .font(.caption2)
                                        .foregroundColor(Color.black)
                                        .padding(12)
                                }
                            }
                            .fixedSize()
                        }
                    }
                    HStack {
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        // 선택된 정류장 표시
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.gray6)
                                .cornerRadius(8)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray4, lineWidth: 1)
                                }
                            HStack {
                                Text("\(busStopAlert?.arrivalBusStop.nodenm ?? "선택해주세요")") // 폰트 수정
                                    .foregroundColor(Color.black)
                                    .font(.regular16)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                Spacer()
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 20)
                    }
                    HStack(spacing: 2) {
                        Text("일어날 정류장")
                            .font(.medium16)
                            .foregroundColor(Color.black)
                        Image(systemName: "asterisk")
                            .foregroundColor(Color.brand)
                            .font(.regular10)
                            .bold()
                            .padding(.trailing)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray4, lineWidth: 1)
                                }
                            
                            HStack {
                                Text(selectedStation)
                                    .foregroundColor(Color.black)
                                    .font(.regular16)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.gray3)
                                    .font(.regular10)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture {
                            showSheet = true
                        }
                        
                        Spacer()
                        Spacer()
                        Text("전에 알람")
                            .foregroundColor(Color.gray1)
                            .font(.regular16)
                    }
                    .padding(.bottom, 20)
                    // 알람 레이블 입력 필드
                    HStack {
                        Text("알람 레이블")
                            .foregroundColor(Color.black)
                            .font(.regular16)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray4, lineWidth: 1)
                                }
                            HStack {
                                TextField("통학", text: $label, prompt: Text("통학").foregroundColor(Color.gray4))
                                    .foregroundColor(Color.black)
                                    .font(.regular16)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                Spacer()
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 10)
                    }
                    
                    Spacer()
                }
                .padding(20)
                Spacer()
                .overlay {
                    if showSheet {
                        StationPickerModal(isPresented: $showSheet, selectedStation: $selectedStation, alert: $busStopAlert)
                    } else {
                        EmptyView()
                    }
                }
                .onAppear {
                    if busStopAlert?.alertBusStop == 0 {
                        selectedStation = "정류장 수"
                    }
                }
            }
            .background(Color.white)
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    if selectedStation != "정류장 수" && label != "" {
                        saveAlert()
                        saveBusstop()
                        dismiss()
                    }
                }) {
                    Text("저장")
                        .font(.regular16)
                        .foregroundColor(Color.brand)
                }
            }
        }
    }
    
    // 알람 저장 함수
    private func saveAlert() {
        guard let selectedBus = busStopAlert?.bus,
              let selectedBusStop = busStopAlert?.arrivalBusStop else {
            print("버스와 정류장을 선택하세요.")
            return
        }
        
        // 알람 객체 생성
        let newAlert = BusAlert(id: UUID().uuidString,
                                cityCode: 21, // 예시로 cityCode 설정
                                busNo: selectedBus.routeno, // 선택된 버스의 번호
                                routeid: selectedBus.routeid, // 선택된 버스의 routeid
                                arrivalBusStopID: selectedBusStop.nodeid, // 선택된 정류장의 ID
                                arrivalBusStopNm: selectedBusStop.nodenm,
                                alertBusStop: busStopAlert!.alertBusStop, // 사용자가 설정한 알람 줄 정류장
                                alertLabel: label, // 사용자가 입력한 알람 레이블
                                alertSound: true, // 알람 사운드 활성화
                                alertHaptic: true, // 해프틱 피드백 활성화
                                alertCycle: nil,
                                updowncd: selectedBusStop.updowncd)
        
        // 데이터베이스에 저장
        do {
            try modelContext.insert(newAlert) // 모델 컨텍스트에 추가
            print("알람이 저장되었습니다.")
        } catch {
            print("알람 저장 실패: \(error)")
        }
    }
    
    
    private func saveBusstop() {
        guard !(busStopAlert?.allBusStop.isEmpty)! else {
            print("버스를 선택하세요.")
            return
        }
        
        // selectedBus.routeid가 이미 존재하는지 확인
        let routeExists = busStopLocal.contains { existingBusStop in
            existingBusStop.routeid == busStopAlert?.bus.routeid
        }
        
        // 같은 routeid가 존재하면 저장하지 않음
        if routeExists {
            print("routeid \(busStopAlert?.bus.routeid ?? "알 수 없음")이 이미 존재합니다. 저장하지 않았습니다.")
            return // 중복된 경우, 함수 종료
        }
        
        // routeid가 존재하지 않으면 저장
        for busStop in busStopAlert!.allBusStop {
            let newBusStopLocal = BusStopLocal(
                id: UUID().uuidString,
                routeid: busStop.routeid,
                nodeid: busStop.nodeid,
                nodenm: busStop.nodenm,
                nodeno: busStop.nodeno,
                nodeord: busStop.nodeord,
                gpslati: busStop.gpslati,
                gpslong: busStop.gpslong,
                updowncd: busStop.updowncd
            )
            
            // 데이터베이스에 저장
            do {
                try modelContext.insert(newBusStopLocal) // 모델 컨텍스트에 추가
                print("버스 정류장이 저장되었습니다.")
                
            } catch {
                print("버스 정류장 저장 실패: \(error)")
            }
        }
    }
}


//#Preview {
//    AlertSettingMain()
//}
