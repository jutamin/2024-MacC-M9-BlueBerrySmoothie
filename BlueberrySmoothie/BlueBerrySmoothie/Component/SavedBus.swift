//
//  SavedBus.swift
//  BlueBerrySmoothie
//
//  Created by 문호 on 11/4/24.
//

import SwiftUI

struct SavedBus: View {
//    @State private var busAlert: BusAlert // 수정 가능하게 변경
    let busStopLocals: [BusStopLocal]
    let busAlert: BusAlert?
    var isSelected: Bool = false
    var onDelete: () -> Void // 삭제 핸들러
    @State private var alertShowing = false
    @State private var isEditing: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.brand : Color.white, lineWidth: 2)
                }
            VStack {
                HStack(alignment: .bottom) {
                    Text(busAlert?.alertLabel ?? "알림")
                        .font(.title2)
                        .foregroundColor(Color.gray2)
                    Spacer()
                    Menu {
                        Button(action: {
                            // 수정
                            isEditing = true
                        }, label: {
                            Label("수정", systemImage: "pencil")
                        })
                        
                        Button(action: {
                            // 삭제
                            alertShowing = true
                        }, label: {
                            Label("삭제", systemImage: "trash")
                                .foregroundStyle(.red)
                        })
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(Color.gray4)
                            .padding(.vertical, 20)
                    }
                    
                }
                HStack {
                    Text(busAlert?.busNo ?? "버스번호없음")
                        .font(.title3)
                    Text(busAlert?.arrivalBusStopNm ?? "도착정류장")
                        .font(.title3)
                    
                    Spacer()
                }
                .foregroundColor(Color.black)
                .padding(.bottom, 4)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "bell.fill")
                        .font(.caption2)
                        .foregroundColor(Color.brand)
                    Text("\(busAlert!.alertBusStop) 정류장 전 알람")
                        .font(.caption1)
                        .foregroundColor(Color.brand)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 2, height: 12)
                        .background(Color.gray5)
                    
                    Text(findAlertBusStop(busAlert: busAlert!, busStops: busStopLocals)?.nodenm ?? "정류장명없음")
                        .font(.caption1)
                        .foregroundColor(Color.gray3)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .sheet(isPresented: $isEditing) {
            NavigationView{
                AlertSettingMain(busAlert: busAlert, isEditing: true) // `busAlert`을 `AlertSettingMain`으로 전달
            }
        }
        .alert("알람 삭제", isPresented: $alertShowing) {
            Button("삭제", role: .destructive) {
                onDelete()
            }
            Button("취소", role: .cancel){}
        } message: {
            Text("알람을 삭제하시겠습니까?")
        }
    }
}

